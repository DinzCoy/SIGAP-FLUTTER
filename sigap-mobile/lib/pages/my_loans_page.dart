// lib/pages/my_loans_page.dart
// Halaman Daftar Peminjaman User

import 'package:flutter/material.dart';
import '../models/loan_model.dart';
import '../services/loan_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
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
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 50) {
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
                AppButton.primary(
                  label: 'Tutup',
                  onTap: () => Navigator.pop(context),
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

  String _selectedFilter = 'Semua';

  Widget _buildFilterChips() {
    final filters = ['Semua', 'Menunggu', 'Diterima', 'Ditolak', 'Selesai'];
    return SizedBox(
      height: 50,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter;
          return ChoiceChip(
            label: Text(
              filter,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.white : AppColors.slate,
              ),
            ),
            selected: isSelected,
            selectedColor: AppColors.primary,
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.border,
              ),
            ),
            onSelected: (selected) {
              if (selected) {
                setState(() => _selectedFilter = filter);
              }
            },
          );
        },
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

    final filteredLoans = _loans.where((loan) {
      if (_selectedFilter == 'Semua') return true;
      if (_selectedFilter == 'Menunggu') return loan.status == 'pending';
      if (_selectedFilter == 'Diterima') return loan.status == 'active';
      if (_selectedFilter == 'Ditolak') return loan.status == 'rejected';
      if (_selectedFilter == 'Selesai') return loan.status == 'returned';
      return true;
    }).toList();

    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight + 16),
        _buildFilterChips(),
        const SizedBox(height: 8),
        Expanded(
          child: filteredLoans.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: EmptyState(
                      icon: Icons.assignment_turned_in_outlined,
                      message: 'Tidak Ada Riwayat',
                      subMessage: 'Belum ada riwayat peminjaman aset untuk kategori ini.',
                      actionLabel: 'Refresh',
                      onAction: _fetchInitialData,
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _fetchInitialData,
                  color: AppColors.primary,
                  child: ListView.separated(
                    controller: _scrollController,
                    padding: EdgeInsets.only(
                      top: 8,
                      left: 16,
                      right: 16,
                      bottom: 16 + MediaQuery.of(context).padding.bottom,
                    ),
                    itemCount: filteredLoans.length + (_hasMoreData ? 1 : 0),
                    separatorBuilder: (_, _) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      if (index == filteredLoans.length) {
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

                      final loan = filteredLoans[index];
                      return FadeIn(
                        delay: Duration(milliseconds: 50 * (index % _itemsPerPage)),
                        child: LoanCard(
                          loan: loan,
                          onTap: () => _showLoanDetails(loan),
                          onReturn: loan.isAktif && loan.isPinjam
                              ? () => _returnAsset(loan.id)
                              : null,
                        ),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.embeddedMode) {
      // Dalam tab dashboard — tanpa AppBar, SafeArea di atas
      return SafeArea(top: false, child: _buildBody());
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Peminjaman')),
      body: _buildBody(),
    );
  }
}
