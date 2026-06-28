// lib/pages/admin_loans_page.dart
// Halaman Admin untuk Mengelola Peminjaman dan Mutasi

import 'package:flutter/material.dart';
import '../models/loan_model.dart';
import '../services/loan_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/common/app_skeletons.dart';
import '../widgets/common/empty_state.dart';
import '../widgets/common/app_snackbar.dart';
import '../widgets/loan/admin_loan_card.dart';
import '../widgets/loan/loan_process_dialog.dart';
import '../widgets/loan/return_asset_dialog.dart';
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
    _tabController = TabController(length: 4, vsync: this);
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
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 50) {
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
      if (_tabController.index == 3) status = 'mutasi';

      final result = await LoanService.getAllLoans(
        status: status,
        page: _currentPage,
        limit: _itemsPerPage,
      );

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
      if (_tabController.index == 3) status = 'mutasi';

      final result = await LoanService.getAllLoans(
        status: status,
        page: _currentPage,
        limit: _itemsPerPage,
      );

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
          String errMsg = e.toString();
          if (errMsg.startsWith('Exception: ')) errMsg = errMsg.substring(11);
          _showSnack('Gagal: $errMsg', isError: true);
        }
      }
    }
  }

  void _showSnack(String message, {required bool isError}) {
    if (isError) {
      AppSnackbar.showError(context, title: 'Gagal', message: message);
    } else {
      AppSnackbar.showSuccess(context, title: 'Berhasil', message: message);
    }
  }

  Future<void> _returnAsset(int loanId) async {
    final String? kondisi = await showDialog<String>(
      context: context,
      builder: (ctx) => const ReturnAssetDialog(),
    );

    if (kondisi != null) {
      if (!mounted) return;
      try {
        await LoanService.returnAsset(loanId: loanId, kondisiKembali: kondisi);
        _fetchInitialData();
        if (mounted) {
          AppSnackbar.showSuccess(context, title: 'Berhasil', message: 'Aset berhasil dikembalikan');
        }
      } catch (e) {
        if (mounted) {
          String errMsg = e.toString();
          if (errMsg.startsWith('Exception: ')) errMsg = errMsg.substring(11);
          AppSnackbar.showError(context, title: 'Gagal', message: errMsg);
        }
      }
    }
  }

  void _showLoanDetails(LoanModel loan) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  loan.jenis == 'permanen' ? 'Detail Mutasi' : 'Detail Peminjaman',
                  style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 20),
                _buildDetailRow(loan.jenis == 'permanen' ? 'ID Mutasi' : 'ID Peminjaman', '#${loan.id}'),
                _buildDetailRow('Peminjam', loan.namaUser ?? 'User ID: ${loan.userId}'),
                _buildDetailRow('Aset', loan.namaAset),
                _buildDetailRow('Pemilik Aset', loan.assetOwner ?? '-'),
                _buildDetailRow('Kategori / Jenis', loan.jenis == 'permanen' ? 'Mutasi Permanen' : 'Peminjaman'),
                _buildDetailRow('Alasan', loan.alasan),
                const SizedBox(height: 12),
                Divider(color: AppColors.divider),
                const SizedBox(height: 12),
                _buildDetailRow(loan.jenis == 'permanen' ? 'Tanggal Mutasi' : 'Tanggal Pinjam', _formatDate(loan.tanggalMulai ?? loan.createdAt)),
                if (loan.jenis != 'permanen')
                  _buildDetailRow('Kapan Dikembalikan', _formatDate(loan.tanggalKembali ?? loan.tanggalDikembalikan)),
                _buildDetailRow('Status Saat Ini', loan.statusInfo['label']),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: AppButton.secondary(
                        label: 'Tutup',
                        onTap: () => Navigator.pop(context),
                      ),
                    ),
                    if (loan.isAktif && loan.isPinjam) ...[
                      const SizedBox(width: 16),
                      Expanded(
                        child: AppButton.primary(
                          label: 'Kembalikan',
                          onTap: () {
                            Navigator.pop(context);
                            _returnAsset(loan.id);
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return '-';
    try {
      final date = DateTime.parse(rawDate);
      return '${date.day}-${date.month}-${date.year}';
    } catch (e) {
      return rawDate;
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.ink),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: SafeArea(
          child: ListSectionSkeleton(title: 'Memuat Data...', itemCount: 5),
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
                style: TextStyle(color: AppColors.inkMute),
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
            return Padding(
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
            onTap: () => _showLoanDetails(_loans[index]),
            onReturn: _loans[index].isAktif && _loans[index].isPinjam
                ? () => _returnAsset(_loans[index].id)
                : null,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final premiumTabBar = Container(
      margin: EdgeInsets.symmetric(
        horizontal: widget.embeddedMode ? 20 : 16,
        vertical: 8,
      ),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppColors.radiusPill),
        boxShadow: AppColors.floatShadow,
        border: Border.all(color: AppColors.border),
      ),
      child: TabBar(
        controller: _tabController,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppColors.radiusPill),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: AppTextStyles.labelMedium.copyWith(
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
        splashBorderRadius: BorderRadius.circular(AppColors.radiusPill),
        tabs: const [
          Tab(text: 'Menunggu'),
          Tab(text: 'Aktif'),
          Tab(text: 'Selesai'),
          Tab(text: 'Mutasi'),
        ],
      ),
    );

    if (widget.embeddedMode) {
      return SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top + 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.swap_horiz_rounded, color: AppColors.primary, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Peminjaman Aset',
                          style: AppTextStyles.headlineSmall.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                          ),
                        ),
                        Text(
                          'Kelola persetujuan & riwayat pinjaman',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            premiumTabBar,
            Expanded(child: _buildBody()),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Peminjaman'),
        elevation: 0,
        backgroundColor: AppColors.primary,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Container(
            color: AppColors.background,
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: premiumTabBar,
          ),
        ),
      ),
      body: _buildBody(),
    );
  }
}
