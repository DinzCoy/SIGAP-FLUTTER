// lib/pages/notifications_page.dart
// Halaman untuk menampilkan daftar notifikasi

import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';
import '../theme/app_colors.dart';
import '../widgets/common/app_skeletons.dart';
import '../widgets/common/empty_state.dart';
import '../widgets/common/app_button.dart';
import '../widgets/notifications/notification_item.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final ScrollController _scrollController = ScrollController();
  
  List<NotificationModel> _notifications = [];
  
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
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 50) {
      _loadMoreData();
    }
  }

  Future<void> _fetchInitialData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _currentPage = 1;
      _notifications.clear();
      _hasMoreData = true;
    });

    try {
      final rawData = await NotificationService.getNotifications(page: _currentPage, limit: _itemsPerPage);
      final listRaw = rawData['data'] as List? ?? [];
      final allNotifs = listRaw.map((e) => NotificationModel.fromJson(e)).toList();
      
      if (mounted) {
        setState(() {
          _notifications = allNotifs;
          final lastPage = rawData['last_page'] as int? ?? 1;
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
      final rawData = await NotificationService.getNotifications(page: _currentPage, limit: _itemsPerPage);
      
      if (!mounted) return;
      
      setState(() {
        final listRaw = rawData['data'] as List? ?? [];
        final newNotifs = listRaw.map((e) => NotificationModel.fromJson(e)).toList();
        _notifications.addAll(newNotifs);
        
        final lastPage = rawData['last_page'] as int? ?? 1;
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

  Future<void> _markAsRead(NotificationModel notif) async {
    if (notif.isRead) return;
    try {
      await NotificationService.markAsRead(notif.id);
      _fetchInitialData();
    } catch (e) {
      debugPrint('Failed to mark as read: $e');
    }
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: SafeArea(
          child: ListSectionSkeleton(
            title: 'Memuat Notifikasi...',
            itemCount: 8,
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
                'Gagal memuat notifikasi:\n$_errorMessage',
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

    if (_notifications.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: EmptyState(
            icon: Icons.notifications_off_outlined,
            message: 'Belum Ada Notifikasi',
            subMessage: 'Semua informasi terbaru akan muncul di sini.',
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
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _notifications.length + (_hasMoreData ? 1 : 0),
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          if (index == _notifications.length) {
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

          return NotificationItem(
            notif: _notifications[index],
            onTap: () => _markAsRead(_notifications[index]),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notifikasi'),
      ),
      body: _buildBody(),
    );
  }
}
