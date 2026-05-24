import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../common/premium_background.dart';

/// DASHBOARD HEADER V4 — The "Zero Leak" Edition.
/// Arsitektur:
/// 1. SliverAppBar transparan.
/// 2. FlexibleSpaceBar menggambar Mesh + Profile + Curve sekaligus.
/// 3. Konten dimulai tepat setelah curve tanpa sliver tambahan di antaranya.
class DashboardHeaderV2 extends StatelessWidget {
  final String name;
  final String role;
  final VoidCallback? onNotification;
  final VoidCallback? onLogout;

  const DashboardHeaderV2({
    super.key,
    required this.name,
    required this.role,
    this.onNotification,
    this.onLogout,
  });

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 11) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 200, // Sedikit lebih tinggi untuk menampung curve
      backgroundColor: AppColors.primary,
      elevation: 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      leadingWidth: 0,
      leading: const SizedBox.shrink(),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 8),
          Text(
            'SIGAP',
            style: AppTextStyles.headlineSmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
      actions: [
        _buildActionGroup(),
        const SizedBox(width: 16),
      ],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: _HeaderBackground(
          name: name,
          greeting: _getGreeting(),
        ),
      ),
    );
  }

  Widget _buildActionGroup() {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (onNotification != null)
            _SmallIconButton(icon: Icons.notifications_none_rounded, onPressed: onNotification!),
          if (onLogout != null)
            _SmallIconButton(icon: Icons.logout_rounded, onPressed: onLogout!),
        ],
      ),
    );
  }
}

class _SmallIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  const _SmallIconButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: Colors.white, size: 20),
      onPressed: onPressed,
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      constraints: const BoxConstraints(),
    );
  }
}

class _HeaderBackground extends StatelessWidget {
  final String name;
  final String greeting;
  const _HeaderBackground({required this.name, required this.greeting});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(now);

    return Stack(
      children: [
        // 1. Mesh Gradient (Full)
        Positioned.fill(child: CustomPaint(painter: HeaderMeshPainter())),

        // 2. Profile Section
        Positioned(
          left: 20,
          right: 20,
          bottom: 55, // Dinaikkan sedikit agar tidak tertutup curve
          child: Row(
            children: [
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
                    ),
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : '?',
                        style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                      child: const Icon(Icons.check, color: Colors.white, size: 10),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$greeting,',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      name,
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formattedDate,
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // 3. THE PERFECT CURVE (Oversheet)
        // Diletakkan di paling bawah Stack, menempel ke dasar FlexibleSpaceBar.
        Positioned(
          left: 0,
          right: 0,
          bottom: -1, // -1 untuk overlap sedikit agar tidak ada celah pixel
          child: Container(
            height: 30,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
          ),
        ),
      ],
    );
  }
}

/// DASHBOARD TRANSITION ZONE — Sekarang hanya berisi Search Bar.
/// Background sudah ditangani oleh Header (oversheet curve).
class DashboardTransitionZone extends StatelessWidget {
  final VoidCallback? onSearchTap;
  final List<QuickAction> quickActions;

  const DashboardTransitionZone({
    super.key,
    this.onSearchTap,
    this.quickActions = const [],
  });

  @override
  Widget build(BuildContext context) {
    // Tanpa outer container ungu, langsung putih.
    return Container(
      color: AppColors.background,
      child: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, quickActions.isEmpty ? 20 : 0),
            child: GestureDetector(
              onTap: onSearchTap,
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Icon(Icons.search_rounded, color: AppColors.primary, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Cari aset, tiket, atau bantuan...',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.inkMute),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.tune_rounded, color: AppColors.primary, size: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (quickActions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
              child: Row(
                children: quickActions
                    .map((action) => Expanded(child: _QuickActionChip(action: action)))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class QuickAction {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const QuickAction({required this.icon, required this.label, required this.onTap});
}

class _QuickActionChip extends StatelessWidget {
  final QuickAction action;
  const _QuickActionChip({required this.action});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: action.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border, width: 1),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(action.icon, color: AppColors.primary, size: 20),
              ),
              const SizedBox(height: 6),
              Text(
                action.label,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.ink),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
