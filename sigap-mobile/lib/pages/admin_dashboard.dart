import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/dashboard_service.dart';
import '../theme/app_colors.dart';
import '../widgets/dashboard/dashboard_header_v2.dart';
import '../widgets/dashboard/stat_panel.dart';
import '../widgets/dashboard/dashboard_bottom_nav.dart';
import '../widgets/dashboard/recent_tickets_section.dart';
import '../widgets/common/app_skeletons.dart';
import '../widgets/common/logout_dialog.dart';
import '../widgets/common/premium_background.dart';

import 'profile_page.dart';
import 'asset_scanner_page.dart';
import 'admin_loans_page.dart';
import 'notifications_page.dart';
import 'all_tickets_page.dart';
import 'leaderboard_page.dart';
import '../widgets/common/fade_in.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int _selectedIndex = 0;
  bool _isLoading = true;
  String _adminName = 'Admin';

  int _activeTickets  = 0;
  int _pendingTickets = 0;
  int _pendingLoans   = 0;
  List<Map<String, dynamic>> _recentTickets = [];

  @override
  void initState() {
    super.initState();
    _loadName();
    _fetchData();
  }

  Future<void> _loadName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _adminName = prefs.getString('user_name') ?? 'Admin');
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    final data = await DashboardService.fetchAdminDashboard();
    if (data != null && mounted) {
      final stats = data['stats'] as Map<String, dynamic>? ?? {};
      final list  = (data['recent_tickets'] as List?) ?? [];
      setState(() {
        _activeTickets  = stats['active_tickets']  ?? 0;
        _pendingTickets = stats['pending_tickets'] ?? 0;
        _pendingLoans   = stats['pending_loans']   ?? 0;
        _recentTickets  = list.cast<Map<String, dynamic>>();
      });
    }
    if (mounted) setState(() => _isLoading = false);
  }

  void _onNavTap(int i) {
    setState(() => _selectedIndex = i);
  }

  Widget _buildBody() {
    // Tab 1 = Laporan Tiket (embedded)
    if (_selectedIndex == 1) {
      return const AllTicketsPage();
    }
    // Tab 2 = Pinjaman (embedded)
    if (_selectedIndex == 2) {
      return const AdminLoansPage(embeddedMode: true);
    }
    // Tab 3 = Profil (embedded)
    if (_selectedIndex == 3) {
      return const ProfilePage();
    }

    // Tab 0 = Beranda
    return RefreshIndicator(
      onRefresh: _fetchData,
      color: AppColors.primary,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          DashboardHeaderV2(
            name: _adminName,
            role: 'Administrator SIGAP',
            onNotification: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotificationsPage()),
            ),
            onLogout: () => LogoutDialog.show(context),
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [
                DashboardTransitionZone(
                  onSearchTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Fitur pencarian admin segera hadir')),
                    );
                  },
                  quickActions: [
                    QuickAction(
                      icon: Icons.qr_code_scanner_rounded,
                      label: 'Scan Aset',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AssetScannerPage()),
                      ),
                    ),
                    QuickAction(
                      icon: Icons.assignment_outlined,
                      label: 'Peminjaman',
                      onTap: () => setState(() => _selectedIndex = 2),
                    ),
                    QuickAction(
                      icon: Icons.confirmation_number_outlined,
                      label: 'Daftar Tiket',
                      onTap: () => setState(() => _selectedIndex = 1),
                    ),
                    QuickAction(
                      icon: Icons.leaderboard_outlined,
                      label: 'Top Teknisi',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LeaderboardPage()),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      FadeIn(
                        delay: const Duration(milliseconds: 200),
                        child: _isLoading
                            ? const StatPanelSkeleton()
                            : StatPanel(items: [
                                StatItem(
                                  value: '$_activeTickets',
                                  label: 'Tiket Aktif',
                                  icon: Icons.confirmation_number_outlined,
                                  iconColor: AppColors.primary,
                                ),
                                StatItem(
                                  value: '$_pendingTickets',
                                  label: 'Tiket Baru',
                                  icon: Icons.inbox_outlined,
                                  iconColor: AppColors.accent,
                                ),
                                StatItem(
                                  value: '$_pendingLoans',
                                  label: 'Pinjaman',
                                  icon: Icons.swap_horiz_rounded,
                                  iconColor: AppColors.success,
                                  onTap: () => setState(() => _selectedIndex = 2),
                                ),
                              ]),
                      ),
                      const SizedBox(height: 24),
                      FadeIn(
                        delay: const Duration(milliseconds: 400),
                        child: RecentTicketsSection(
                          title: 'Tiket Terbaru',
                          tickets: _recentTickets,
                          isLoading: _isLoading,
                          emptyMessage: 'Tidak ada tiket masuk',
                          onSeeAll: () => setState(() => _selectedIndex = 1),
                        ),
                      ),
                      const SizedBox(height: 100),
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
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AssetScannerPage()));
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.qr_code_scanner_rounded, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart_rounded),
            label: 'Laporan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz_outlined),
            activeIcon: Icon(Icons.swap_horiz_rounded),
            label: 'Pinjaman',
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
