import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/dashboard_service.dart';
import '../theme/app_colors.dart';
import '../widgets/dashboard/dashboard_header_v2.dart';
import '../widgets/dashboard/stat_panel.dart';
import '../widgets/dashboard/dashboard_bottom_nav.dart';
import '../widgets/dashboard/recent_tickets_section.dart';
import '../widgets/common/section_header.dart';
import '../widgets/common/app_skeletons.dart';
import '../widgets/common/logout_dialog.dart';
import '../widgets/common/premium_background.dart';

import 'profile_page.dart';
import 'search_page.dart';
import 'it_service_page.dart';
import 'my_tickets_page.dart';
import 'asset_scanner_page.dart';
import 'my_loans_page.dart';
import 'notifications_page.dart';
import 'asset_catalog_page.dart';
import 'leaderboard_page.dart';
import 'my_assets_page.dart';
import '../widgets/common/fade_in.dart';

class UserDashboardPage extends StatefulWidget {
  const UserDashboardPage({super.key});

  @override
  State<UserDashboardPage> createState() => _UserDashboardPageState();
}

class _UserDashboardPageState extends State<UserDashboardPage> {
  int _selectedIndex = 0;
  bool _isLoading = true;
  String _userName = 'Pengguna';
  String _photoUrl = '';

  // Data real dari Laravel
  int _pendingCount = 0;
  int _inProgressCount = 0;
  int _completedCount = 0;
  List<Map<String, dynamic>> _recentTickets = [];

  @override
  void initState() {
    super.initState();
    _loadNameFromPrefs();
    _fetchDashboardData();
  }

  Future<void> _loadNameFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? 'Pengguna';
      _photoUrl = prefs.getString('user_photo_url') ?? '';
    });
  }

  Future<void> _fetchDashboardData() async {
    setState(() => _isLoading = true);
    final data = await DashboardService.fetchUserDashboard();
    if (data != null && mounted) {
      final stats = data['stats'] as Map<String, dynamic>? ?? {};
      final tickets = (data['recent_tickets'] as List?) ?? [];
      setState(() {
        _pendingCount = stats['pending'] ?? 0;
        _inProgressCount = stats['in_progress'] ?? 0;
        _completedCount = stats['completed'] ?? 0;
        _recentTickets = tickets.cast<Map<String, dynamic>>();
      });
    }
    if (mounted) setState(() => _isLoading = false);
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      _loadNameFromPrefs();
    }
    // Index 1 (Pinjaman) & 2 (Laporan) & 3 (Profil) di-embed, bukan push
    setState(() => _selectedIndex = index);
  }

  Widget _buildBody() {
    return IndexedStack(
      index: _selectedIndex,
      children: [
        _buildHomeContent(),
        const MyLoansPage(embeddedMode: true),
        const MyTicketsPage(embeddedMode: true),
        const ProfilePage(),
      ],
    );
  }

  Widget _buildHomeContent() {
    return RefreshIndicator(
      onRefresh: _fetchDashboardData,
      color: AppColors.primary,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          DashboardHeaderV2(
            name: _userName,
            photoUrl: _photoUrl,
            role: 'Pengguna SIGAP',
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SearchPage()),
                    );
                  },
                  quickActions: [
                    QuickAction(
                      icon: Icons.report_problem_outlined,
                      label: 'Buat Laporan',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ItServicePage(),
                        ),
                      ),
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
                      icon: Icons.swap_horiz_outlined,
                      label: 'Pinjam Aset',
                      onTap: () => setState(() => _selectedIndex = 1),
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
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      if (_isLoading) ...[
                        const SectionHeader(title: 'Status Tiket Saya'),
                        const SizedBox(height: 10),
                        const StatPanelSkeleton(),
                        const SizedBox(height: 24),
                        RecentTicketsSection(
                          title: 'Laporan Terakhir',
                          tickets: const [],
                          isLoading: true,
                          onSeeAll: () {},
                        ),
                      ] else ...[
                        FadeIn(
                          delay: const Duration(milliseconds: 200),
                          child: const SectionHeader(
                            title: 'Status Tiket Saya',
                          ),
                        ),
                        const SizedBox(height: 10),
                        FadeIn(
                          delay: const Duration(milliseconds: 300),
                          child: StatPanel(
                            items: [
                              StatItem(
                                value: '$_pendingCount',
                                label: 'Pending',
                                icon: Icons.access_time_rounded,
                                iconColor: AppColors.warning,
                              ),
                              StatItem(
                                value: '$_inProgressCount',
                                label: 'Proses',
                                icon: Icons.settings_suggest_outlined,
                                iconColor: AppColors.primary,
                              ),
                              StatItem(
                                value: '$_completedCount',
                                label: 'Selesai',
                                icon: Icons.check_circle_outline_rounded,
                                iconColor: AppColors.success,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ── Shortcut Card Pinjaman ──
                        FadeIn(
                          delay: const Duration(milliseconds: 350),
                          child: _LoanShortcutCard(
                            onTap: () => setState(() => _selectedIndex = 1),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ── Shortcut Card Aset Saya ──
                        FadeIn(
                          delay: const Duration(milliseconds: 375),
                          child:MyAssetShortcutCard(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const MyAssetsPage()),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        FadeIn(
                          delay: const Duration(milliseconds: 400),
                          child: RecentTicketsSection(
                            title: 'Laporan Terakhir',
                            tickets: _recentTickets,
                            isLoading: false,
                            emptyMessage: 'Belum ada laporan dibuat',
                            onSeeAll: () => setState(() => _selectedIndex = 2),
                          ),
                        ),
                      ],
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AssetScannerPage()),
          );
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
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz_outlined),
            activeIcon: Icon(Icons.swap_horiz_rounded),
            label: 'Pinjaman',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report_outlined),
            activeIcon: Icon(Icons.report_rounded),
            label: 'Laporan',
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

// ─── Shortcut Card Pinjaman di Beranda ───────────────────────────────────────

class _LoanShortcutCard extends StatelessWidget {
  final VoidCallback onTap;
  const _LoanShortcutCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.primary.withValues(alpha: 0.75),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.swap_horiz_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Peminjaman Aset',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Lihat riwayat & status peminjaman Anda',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.75),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class _MyAssetShortcutCard extends StatelessWidget {
  final VoidCallback onTap;
  const _MyAssetShortcutCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0EA5E9), // Sky blue
              const Color(0xFF0284C7).withValues(alpha: 0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0EA5E9).withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.devices_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Aset Saya',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Lihat aset yang sedang Anda pegang',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
