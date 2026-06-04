// lib/pages/my_tickets_page.dart
// Halaman Riwayat Layanan IT (Tiket Saya)

import 'package:flutter/material.dart';
import '../models/ticket_model.dart';
import '../services/ticket_service.dart';
import '../widgets/common/empty_state.dart';
import '../widgets/common/app_skeletons.dart';
import '../widgets/ticket/admin_ticket_card.dart';
import '../widgets/ticket/ticket_status_dialog.dart';
import '../widgets/common/app_snackbar.dart';
import '../widgets/common/fade_in.dart';
import '../widgets/common/premium_background.dart';
import '../widgets/common/app_button.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AllTicketsPage extends StatefulWidget {
  final bool embeddedMode;
  const AllTicketsPage({super.key, this.embeddedMode = false});

  @override
  State<AllTicketsPage> createState() => _AllTicketsPageState();
}

class _AllTicketsPageState extends State<AllTicketsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  List<TicketModel> _tickets = [];

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
      _tickets.clear();
      _hasMoreData = true;
    });

    try {
      String? status;
      if (_tabController.index == 1) status = 'menunggu';
      if (_tabController.index == 2) status = 'proses';
      if (_tabController.index == 3) status = 'selesai';

      final result = await TicketService.getAllTickets(
        status: status,
        page: _currentPage,
        limit: _itemsPerPage,
      );

      if (mounted) {
        setState(() {
          _tickets = result['data'] as List<TicketModel>;
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
      if (_tabController.index == 1) status = 'menunggu';
      if (_tabController.index == 2) status = 'proses';
      if (_tabController.index == 3) status = 'selesai';

      final result = await TicketService.getAllTickets(
        status: status,
        page: _currentPage,
        limit: _itemsPerPage,
      );

      if (!mounted) return;

      setState(() {
        final newTickets = result['data'] as List<TicketModel>;
        _tickets.addAll(newTickets);

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

  Widget _buildBody() {
    final premiumTabBar = Container(
      margin: EdgeInsets.symmetric(
        horizontal: widget.embeddedMode ? 24 : 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: AppColors.canvasSoft,
        borderRadius: BorderRadius.circular(999),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(999),
          boxShadow: AppColors.floatShadow,
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.bold),
        unselectedLabelStyle: AppTextStyles.labelMedium,
        tabs: const [
          Tab(text: 'Semua'),
          Tab(text: 'Menunggu'),
          Tab(text: 'Proses'),
          Tab(text: 'Selesai'),
        ],
      ),
    );

    Widget content;
    if (_isLoading) {
      content = const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: SafeArea(
          child: ListSectionSkeleton(title: 'Memuat Tiket...', itemCount: 5),
        ),
      );
    } else if (_hasError) {
      content = Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Gagal memuat tiket:\n$_errorMessage',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.inkMute,
                ),
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
    } else if (_tickets.isEmpty) {
      content = Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: EmptyState(
            icon: Icons.inbox_rounded,
            message: 'Tidak ada data',
            subMessage: 'Belum ada tiket yang sesuai dengan status ini.',
            actionLabel: 'Refresh',
            onAction: _fetchInitialData,
          ),
        ),
      );
    } else {
      content = RefreshIndicator(
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
          itemCount: _tickets.length + (_hasMoreData ? 1 : 0),
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            if (index == _tickets.length) {
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

            final ticket = _tickets[index];
            return FadeIn(
              delay: Duration(milliseconds: 50 * (index % _itemsPerPage)),
              child: AdminTicketCard(
                ticket: ticket,
                onUpdateStatus: () async {
                  final result = await showDialog<Map<String, dynamic>>(
                    context: context,
                    builder: (context) => TicketStatusDialog(ticket: ticket),
                  );

                  if (result != null && mounted) {
                    setState(() {
                      _isLoading = true;
                    });
                    try {
                      final statusResult = await TicketService.updateTicketStatus(
                        ticketId: ticket.id,
                        status: result['status'] as String,
                        tanggapan: result['tanggapan'] as String?,
                        technicianId: result['technician_id'] as int?,
                      );
                      
                      if (context.mounted) {
                        AppSnackbar.showSuccess(
                          context,
                          title: 'Berhasil',
                          message: statusResult['message'] ?? 'Status tiket berhasil diperbarui.',
                        );
                        _fetchInitialData();
                      }
                    } catch (e) {
                      if (context.mounted) {
                        setState(() {
                          _isLoading = false;
                        });
                        AppSnackbar.showError(
                          context,
                          title: 'Gagal',
                          message: 'Gagal memperbarui status tiket: $e',
                        );
                      }
                    }
                  }
                },
              ),
            );
          },
        ),
      );
    }

    return Column(
      children: [
        if (!widget.embeddedMode)
          SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight),
        premiumTabBar,
        const SizedBox(height: 8),
        Expanded(child: content),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    child: Icon(Icons.confirmation_number_rounded, color: AppColors.primary, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Daftar Laporan',
                          style: AppTextStyles.headlineSmall.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                          ),
                        ),
                        Text(
                          'Kelola tiket layanan IT yang masuk',
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
            Expanded(child: _buildBody()),
          ],
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.canvasCream,
      appBar: AppBar(
        title: Text('Daftar Laporan', style: AppTextStyles.titleLarge),
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: PremiumBackground(child: _buildBody()),
    );
  }
}
