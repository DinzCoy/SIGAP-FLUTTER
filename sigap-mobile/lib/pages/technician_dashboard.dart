import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/app_colors.dart';

import '../widgets/dashboard/dashboard_header_v2.dart';
import '../widgets/dashboard/stat_panel.dart';
import '../widgets/dashboard/task_item.dart';
import '../widgets/dashboard/dashboard_bottom_nav.dart';
import '../widgets/dashboard/technician_sections.dart';
import '../widgets/common/app_skeletons.dart';
import 'notifications_page.dart';
import '../widgets/common/logout_dialog.dart';
import '../widgets/common/premium_background.dart';
import '../services/dashboard_service.dart';
import '../widgets/common/fade_in.dart';

import 'profile_page.dart';
import 'search_page.dart';
import 'all_tickets_page.dart';
import 'asset_scanner_page.dart';
import 'leaderboard_page.dart';
import 'maintenance_history_page.dart';
import 'asset_catalog_page.dart';

// Teknisi TIDAK perlu fitur pinjaman — role teknisi bertugas memperbaiki aset,
// bukan meminjam. Tab hanya: Beranda | Laporan | Profil

class TechnicianDashboardPage extends StatefulWidget {
  const TechnicianDashboardPage({super.key});

  @override
  State<TechnicianDashboardPage> createState() =>
      _TechnicianDashboardPageState();
}

class _TechnicianDashboardPageState extends State<TechnicianDashboardPage> {
  int _selectedIndex = 0;
  bool _isLoading = true;
  String _techName = 'Teknisi';
  String _roleName = 'Teknisi';
  String _photoUrl = '';

  int _waitingCount = 0;
  int _processCount = 0;
  int _doneCount = 0;
  List<Map<String, dynamic>> _tasks = [];
  List<Map<String, dynamic>> _repairTimeline = [];

  @override
  void initState() {
    super.initState();
    _loadName();
    _fetchData();
  }

  Future<void> _loadName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _techName = prefs.getString('user_name') ?? 'Teknisi';
      _roleName = prefs.getString('user_role') ?? 'Teknisi';
      _photoUrl = prefs.getString('user_photo_url') ?? '';
    });
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    final data = await DashboardService.fetchTechnicianDashboard();
    if (data != null && mounted) {
      final stats = data['stats'] as Map<String, dynamic>? ?? {};
      final list = (data['tasks'] as List?) ?? [];
      final timeline = (data['repair_timeline'] as List?) ?? [];
      setState(() {
        _waitingCount = stats['waiting'] ?? 0;
        _processCount = stats['processing'] ?? 0;
        _doneCount = stats['completed'] ?? 0;
        _tasks = list.cast<Map<String, dynamic>>();
        _repairTimeline = timeline.cast<Map<String, dynamic>>();
      });
    }
    if (mounted) setState(() => _isLoading = false);
  }

  void _onNavTap(int index) {
    if (index == 0) _loadName();
    setState(() => _selectedIndex = index);
  }

  Widget _buildBody() {
    return IndexedStack(
      index: _selectedIndex,
      children: [
        _buildHomeContent(),
        const AllTicketsPage(embeddedMode: true),
        const MaintenanceHistoryPage(embeddedMode: true),
        const ProfilePage(),
      ],
    );
  }

  Widget _buildHomeContent() {
    return RefreshIndicator(
      onRefresh: _fetchData,
      color: AppColors.primary,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          DashboardHeaderV2(
            name: _techName,
            photoUrl: _photoUrl,
            role: _roleName == 'Ketua Tim' ? 'Ketua Tim IT SIGAP' : 'Teknisi IT SIGAP',
            onNotification: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotificationsPage()),
            ),
            onLogout: () => LogoutDialog.show(context),
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DashboardTransitionZone(
                  onSearchTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SearchPage()),
                    );
                  },
                  quickActions: [
                    QuickAction(
                      icon: Icons.qr_code_scanner_rounded,
                      label: 'Scan Aset',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AssetScannerPage(),
                        ),
                      ),
                    ),
                    QuickAction(
                      icon: Icons.history_rounded,
                      label: 'Riwayat Kerja',
                      onTap: () => setState(() => _selectedIndex = 2),
                    ),
                    QuickAction(
                      icon: Icons.menu_book_outlined,
                      label: 'Katalog Aset',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AssetCatalogPage(),
                        ),
                      ),
                    ),
                    QuickAction(
                      icon: Icons.leaderboard_outlined,
                      label: 'Top Teknisi',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LeaderboardPage(),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeIn(
                        delay: const Duration(milliseconds: 200),
                        child: _isLoading
                            ? const StatPanelSkeleton()
                            : StatPanel(
                                items: [
                                  StatItem(
                                    value: '$_waitingCount',
                                    label: 'Ditunggu',
                                    icon: Icons.access_time_filled,
                                    iconColor: AppColors.warning,
                                  ),
                                  StatItem(
                                    value: '$_processCount',
                                    label: 'Proses',
                                    icon: Icons.build_circle,
                                    iconColor: AppColors.primary,
                                  ),
                                  StatItem(
                                    value: '$_doneCount',
                                    label: 'Selesai',
                                    icon: Icons.check_circle,
                                    iconColor: AppColors.success,
                                  ),
                                ],
                              ),
                      ),
                      const SizedBox(height: 24),
                      if (_isLoading)
                        const StatPanelSkeleton()
                      else
                        FadeIn(
                          delay: const Duration(milliseconds: 400),
                          child: TaskActivitySection(
                            tasks: _tasks.map((t) {
                              final name = (t['reporter_name'] ?? '') as String;
                              final parts = name.trim().split(' ');
                              final initials = parts.length >= 2
                                  ? '${parts[0][0]}${parts[1][0]}'
                                  : (name.isNotEmpty ? name[0] : '?');
                              return TaskItem(
                                priority: t['priority'] ?? 'Sedang',
                                initials: initials.toUpperCase(),
                                title: t['title'] ?? 'No Title',
                                subtitle: 'Oleh: ${t['reporter_name'] ?? '-'}',
                                icon: Icons.assignment_rounded,
                                timestamp: t['date'] ?? '--',
                              );
                            }).toList(),
                            onSeeAll: () => setState(() => _selectedIndex = 1),
                          ),
                        ),
                      const SizedBox(height: 24),
                      FadeIn(
                        delay: const Duration(milliseconds: 600),
                        child: RepairTimelineSection(items: _repairTimeline),
                      ),
                      const SizedBox(height: 24),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.background,
      body: PremiumBackground(child: _buildBody()),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AssetScannerPage()),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.qr_code_scanner_rounded, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // 4 item: Beranda | Laporan | [FAB center] | Riwayat | Profil
      bottomNavigationBar: DashboardBottomNav(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_chart_outlined),
            activeIcon: Icon(Icons.insert_chart_rounded),
            label: 'Laporan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_rounded),
            activeIcon: Icon(Icons.history_rounded),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person_rounded),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
