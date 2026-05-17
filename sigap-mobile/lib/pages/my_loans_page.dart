// lib/pages/my_loans_page.dart
// Halaman Daftar Peminjaman User

import 'package:flutter/material.dart';
import '../models/loan_model.dart';
import '../services/loan_service.dart';
import '../theme/app_colors.dart';
import '../widgets/common/app_skeletons.dart';
import '../widgets/common/empty_state.dart';
import '../widgets/loan/loan_card.dart';
import '../widgets/loan/return_asset_dialog.dart';
import '../widgets/common/fade_in.dart';
import '../widgets/common/app_button.dart';

class MyLoansPage extends StatefulWidget {
  /// [embeddedMode] = true → tanpa AppBar (dipakai dalam tab dashboard)
  final bool embeddedMode;
  const MyLoansPage({super.key, this.embeddedMode = false});

  @override
  State<MyLoansPage> createState() => _MyLoansPageState();
}

class _MyLoansPageState extends State<MyLoansPage> {
  final ScrollController _scrollController = ScrollController();
  
  List<LoanModel> _loans = [];
  
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  
  final int _itemsPerPage = 10;
  bool _hasMoreData = false;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
    _scrollController.addListener(_onScroll);
  }
  
  @override
  void dispose() {
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
      _loans.clear();
      _hasMoreData = false;
    });

    try {
      final result = await LoanService.getMyLoans();
      
      if (mounted) {
        setState(() {
          _loans = result;
          _hasMoreData = false; // no pagination for my loans
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
    // getMyLoans is unpaginated from backend.
    return;
  }

  Future<void> _returnAsset(int loanId) async {
    final String? kondisi = await showDialog<String>(
      context: context,
      builder: (ctx) => const ReturnAssetDialog(),
    );

    if (kondisi != null) {
      try {
        await LoanService.returnAsset(loanId: loanId, kondisiKembali: kondisi);
        _fetchInitialData();
        if (mounted) {
          _showSnack('Aset berhasil dikembalikan', isError: false);
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
            title: 'Memuat Peminjaman...',
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
                'Gagal memuat peminjaman:\n$_errorMessage',
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
            icon: Icons.assignment_turned_in_outlined,
            message: 'Tidak Ada Riwayat',
            subMessage: 'Belum ada riwayat peminjaman aset.',
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

          final loan = _loans[index];
          return FadeIn(
            delay: Duration(milliseconds: 50 * (index % _itemsPerPage)),
            child: LoanCard(
              loan: loan,
              onReturn: loan.isAktif && loan.isPinjam
                  ? () => _returnAsset(loan.id)
                  : null,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.embeddedMode) {
      // Dalam tab dashboard — tanpa AppBar, SafeArea di atas
      return SafeArea(
        top: false,
        child: _buildBody(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Peminjaman'),
      ),
      body: _buildBody(),
    );
  }
}
