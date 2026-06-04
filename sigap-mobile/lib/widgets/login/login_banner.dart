import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class LoginBanner extends StatefulWidget {
  final bool isDesktop;

  const LoginBanner({super.key, required this.isDesktop});

  @override
  State<LoginBanner> createState() => _LoginBannerState();
}

class _LoginBannerState extends State<LoginBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(
      begin: 0.0,
      end: -12.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32.0),
      child: SafeArea(
        bottom: false,
        child: widget.isDesktop
            ? Center(child: SingleChildScrollView(child: _buildContent()))
            : _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    final double shieldSize = widget.isDesktop ? 250 : 180;
    final double nameWidth = widget.isDesktop ? 220 : 180;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Shield Logo (Animated Floating & Glowing with Shimmer Glint)
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _floatAnimation.value),
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // (Efek glow telah dihapus sesuai permintaan)
                  // The Shimmer Glint Stack
                  Stack(
                    children: [
                      // Base SVG Shield Logo
                      SvgPicture.asset(
                        'assets/images/logo_sigap.svg',
                        width: shieldSize,
                        height: shieldSize,
                        fit: BoxFit.contain,
                      ),
                      // Slow Shimmer Sweep Overlay
                      Shimmer.fromColors(
                        baseColor: Colors.transparent,
                        highlightColor: Colors.white.withValues(alpha: 0.45),
                        period: const Duration(seconds: 8),
                        child: SvgPicture.asset(
                          'assets/images/logo_sigap.svg',
                          width: shieldSize,
                          height: shieldSize,
                          fit: BoxFit.contain,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        // Spasi diperkecil agar rapat seperti versi web
        const SizedBox(height: 0),
        // Static Name Logo ("SIGAP" cropped)
        ClipRect(
          child: Align(
            alignment: Alignment.center,
            heightFactor: 0.185,
            child: SvgPicture.asset(
              'assets/images/nama_logo.svg',
              width: nameWidth,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Divider line similar to Web version
        Container(
          height: 1.5,
          width: 64,
          color: AppColors.divider.withValues(alpha: 0.4),
        ),
        const SizedBox(height: 24),
        // BPS subtitle/tagline matching Laravel version
        Text(
          'Sistem Guardian Aset dan Pelayanan IT',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.ink,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'BPS PROVINSI SULAWESI SELATAN',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.slate,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 48),
        // Copyright section
        Text(
          '© 2026 Badan Pusat Statistik Provinsi Sulawesi Selatan',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.inkMute2),
        ),
      ],
    );
  }
}
