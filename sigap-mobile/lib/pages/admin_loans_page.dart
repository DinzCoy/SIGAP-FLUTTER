// lib/pages/admin_loans_page.dart
// Halaman Admin untuk Mengelola Peminjaman dan Mutasi

import 'package:flutter/material.dart';
import '../models/loan_model.dart';
import '../services/loan_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/common/app_skeletons.dart';
import '../widgets/common/empty_state.dart';
import '../widgets/loan/admin_loan_card.dart';
import '../widgets/loan/loan_process_dialog.dart';
import '../widgets/common/app_button.dart';

class AdminLoansPage extends StatefulWidget {
  /// [embeddedMode] = true → tanpa AppBar (dipakai dalam tab dashboard)
  final bool embeddedMode;
  const AdminLoansPage({super.key, this.embeddedMode = false});

  @override
  State<AdminLoansPage> createState() => _AdminLoansPageState();
}

class _AdminLoansPageState extends State<AdminLoansPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  
  List<LoanModel> _loans = [];
  
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasError = false;
  String _errorMessage = '';
  
  int _currentPage = 1;
  final int _itemsPerPage = 10;
  bool _hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _fetchInitialData();
      }
    });
    _fetchInitialData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 50) {
      _loadMoreData();
    }
  }

  Future<void> _fetchInitialData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _currentPage = 1;
      _loans.clear();
      _hasMoreData = true;
    });

    try {
      String? status;
      if (_tabController.index == 0) status = 'menunggu';
      if (_tabController.index == 1) status = 'disetujui';
      if (_tabController.index == 2) status = 'selesai';

      final result = await LoanService.getAllLoans(status: status, page: _currentPage, limit: _itemsPerPage);
      
      if (mounted) {
        setState(() {
          _loans = result['data'] as List<LoanModel>;
          final lastPage = result['last_page'] as int;
          _hasMoreData = _currentPage < lastPage;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = e.toString();
        });
      }
    }
  }

  Future<void> _loadMoreData() async {
    if (_isLoadingMore || !_hasMoreData || _isLoading) return;

    setState(() {
      _isLoadingMore = true;
    });

    _currentPage++;
    
    try {
      String? status;
      if (_tabController.index == 0) status = 'menunggu';
      if (_tabController.index == 1) status = 'disetujui';
      if (_tabController.index == 2) status = 'selesai';

      final result = await LoanService.getAllLoans(status: status, page: _currentPage, limit: _itemsPerPage);
      
      if (!mounted) return;
      
      setState(() {
        final newLoans = result['data'] as List<LoanModel>;
        _loans.addAll(newLoans);
        
        final lastPage = result['last_page'] as int;
        _hasMoreData = _currentPage < lastPage;
        _isLoadingMore = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _currentPage--; // Revert page
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _processLoan(LoanModel loan, bool isApprove) async {
    final String? catatan = await showDialog<String>(
      context: context,
      builder: (ctx) => LoanProcessDialog(isApprove: isApprove),
    );

    if (catatan != null) {
      try {
        await LoanService.approveLoan(
          loanId: loan.id,
          status: isApprove ? 'disetujui' : 'ditolak',
          catatan: catatan,
        );
        _fetchInitialData();
        if (mounted) {
          _showSnack('Berhasil diproses', isError: false);
        }
      } catch (e) {
        if (mounted) {
          _showSnack('Gagal: $e', isError: true);
        }
      }
    }
  }

  void _showSnack(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: SafeArea(
          child: ListSectionSkeleton(
            title: 'Memuat Data...',
            itemCount: 5,
          ),
        ),
      );
    }

    if (_hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Gagal memuat data:\n$_errorMessage',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.inkMute),
              ),
              const SizedBox(height: 24),
              AppButton.primary(
                label: 'Coba Lagi',
                onTap: _fetchInitialData,
                fullWidth: false,
              ),
            ],
          ),
        ),
      );
    }

    if (_loans.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: EmptyState(
            icon: Icons.inbox_outlined,
            message: 'Tidak Ada Data',
            subMessage: 'Tidak ada peminjaman di kategori ini.',
            actionLabel: 'Refresh',
            onAction: _fetchInitialData,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchInitialData,
      color: AppColors.primary,
      child: ListView.separated(
        controller: _scrollController,
        padding: EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
          bottom: 16 + MediaQuery.of(context).padding.bottom,
        ),
        itemCount: _loans.length + (_hasMoreData ? 1 : 0),
        separatorBuilder: (_, _) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          if (index == _loans.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
              ),
            );
          }

          return AdminLoanCard(
            loan: _loans[index],
            onProcess: _processLoan,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabBar = TabBar(
      controller: _tabController,
      indicatorColor: Colors.white,
      indicatorWeight: 3,
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white70,
      labelStyle: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.bold),
      tabs: const [
        Tab(text: 'Menunggu'),
        Tab(text: 'Aktif'),
        Tab(text: 'Selesai'),
      ],
    );

    if (widget.embeddedMode) {
      // Dalam tab dashboard — gunakan DefaultTabController + Column
      return SafeArea(
        top: false,
        child: Column(
          children: [
            Material(
              color: AppColors.primary,
              child: tabBar,
            ),
            Expanded(child: _buildBody()),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Peminjaman (Admin)'),
        bottom: tabBar,
      ),
      body: _buildBody(),
    );
  }
}
