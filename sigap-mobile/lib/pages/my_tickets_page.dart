// lib/pages/my_tickets_page.dart
// Halaman Riwayat Layanan IT (Tiket Saya)

import 'package:flutter/material.dart';
import '../models/ticket_model.dart';
import '../services/ticket_service.dart';
import '../widgets/common/empty_state.dart';
import '../widgets/common/app_skeletons.dart';
import '../widgets/ticket/ticket_card.dart';
import '../widgets/common/fade_in.dart';
import '../widgets/common/premium_background.dart';
import '../widgets/common/app_button.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class MyTicketsPage extends StatefulWidget {
  final bool embeddedMode;
  const MyTicketsPage({super.key, this.embeddedMode = false});

  @override
  State<MyTicketsPage> createState() => _MyTicketsPageState();
}

class _MyTicketsPageState extends State<MyTicketsPage> {
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
      _currentPage = 1;
      _tickets.clear();
      _hasMoreData = true;
    });

    try {
      final result = await TicketService.getMyTickets(
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
      final result = await TicketService.getMyTickets(
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

  String _selectedFilter = 'Semua';

  Widget _buildFilterChips() {
    final filters = ['Semua', 'Menunggu', 'Proses', 'Selesai'];
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
          child: ListSectionSkeleton(title: 'Memuat Tiket...', itemCount: 5),
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
    }

    final filteredTickets = _tickets.where((ticket) {
      if (_selectedFilter == 'Semua') return true;
      if (_selectedFilter == 'Menunggu') return ticket.statusInfo['label'] == 'Menunggu';
      if (_selectedFilter == 'Proses') return ticket.isActive && ticket.statusInfo['label'] != 'Menunggu';
      if (_selectedFilter == 'Selesai') return !ticket.isActive;
      return true;
    }).toList();

    return Column(
      children: [
        SizedBox(height: widget.embeddedMode ? 8 : MediaQuery.of(context).padding.top + kToolbarHeight + 16),
        _buildFilterChips(),
        const SizedBox(height: 8),
        Expanded(
          child: filteredTickets.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: EmptyState(
                      icon: Icons.inbox_rounded,
                      message: 'Tidak Ada Tiket',
                      subMessage: 'Belum ada tiket untuk kategori ini.',
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
                    itemCount: filteredTickets.length + (_hasMoreData ? 1 : 0),
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      if (index == filteredTickets.length) {
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

                      return FadeIn(
                        delay: Duration(milliseconds: 50 * (index % _itemsPerPage)),
                        child: TicketCard(ticket: filteredTickets[index]),
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
                    child: Icon(Icons.history_rounded, color: AppColors.primary, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Riwayat Tiket',
                          style: AppTextStyles.headlineSmall.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                          ),
                        ),
                        Text(
                          'Pantau status laporan layanan IT Anda',
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
        title: Text('Riwayat Tiket', style: AppTextStyles.titleLarge),
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: PremiumBackground(child: _buildBody()),
    );
  }
}
