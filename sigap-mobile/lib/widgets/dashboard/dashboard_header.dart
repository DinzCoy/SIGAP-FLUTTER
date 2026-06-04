import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../common/premium_background.dart';

/// SliverAppBar header dashboard dengan atmospheric mesh gradient.
/// Menggunakan [HeaderMeshPainter] dari premium_background.dart.
/// Dipakai di: admin_dashboard, user_dashboard, technician_dashboard.
class DashboardHeader extends StatelessWidget {
  final String name;
  final String role;
  final VoidCallback? onNotification;
  final VoidCallback? onLogout;

  const DashboardHeader({
    super.key,
    required this.name,
    required this.role,
    this.onNotification,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 180,
      backgroundColor: AppColors.primary,
      elevation: 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      actions: [
        if (onNotification != null)
          _NavIconButton(
            icon: Icons.notifications_outlined,
            onPressed: onNotification!,
          ),
        if (onLogout != null)
          _NavIconButton(icon: Icons.logout_rounded, onPressed: onLogout!),
        const SizedBox(width: AppColors.spaceSm),
      ],
      flexibleSpace: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
        child: FlexibleSpaceBar(
          collapseMode: CollapseMode.parallax,
          background: _HeaderBackground(name: name, role: role),
        ),
      ),
    );
  }
}

class _NavIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _NavIconButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: Colors.white, size: 22),
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: Colors.white.withValues(alpha: 0.1),
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(8),
        minimumSize: const Size(40, 40),
      ),
    );
  }
}

class _HeaderBackground extends StatelessWidget {
  final String name;
  final String role;

  const _HeaderBackground({required this.name, required this.role});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Stack(
        children: [
          // Atmospheric mesh backdrop
          Positioned.fill(child: CustomPaint(painter: HeaderMeshPainter())),

          // Content
          Positioned(
            left: AppColors.spaceLg, // 16px
            right: AppColors.spaceLg,
            bottom: AppColors.spaceXl, // 24px
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Role pill badge — {pill-tag-soft} inverted
                _RoleBadge(role: role),

                const SizedBox(height: AppColors.spaceMd), // 12px
                // Greeting
                Text('Selamat Datang,', style: AppTextStyles.greeting),

                const SizedBox(height: AppColors.spaceXs), // 4px
                // Name — display-md tier
                Text(
                  name,
                  style: AppTextStyles.greetingName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Pill badge untuk role pengguna — warna white/semi-transparent.
class _RoleBadge extends StatelessWidget {
  final String role;

  const _RoleBadge({required this.role});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppColors.spaceMd, // 12px
        vertical: AppColors.spaceXs, // 4px
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppColors.radiusPill),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            role.toUpperCase(),
            style: AppTextStyles.microCap.copyWith(
              color: Colors.white,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}
