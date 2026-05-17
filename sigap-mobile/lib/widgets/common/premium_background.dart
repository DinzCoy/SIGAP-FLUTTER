import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Painter untuk "Mesh Gradient" atmosphere — signature Stripe design.
///
/// Menggunakan organic blob shapes dengan MaskFilter.blur untuk menciptakan
/// efek mesh yang autentik: cream → lavender → indigo → ruby → magenta.
/// Blobs diposisikan di upper-third sebagai backdrop utama.
class MeshGradientPainter extends CustomPainter {
  final double animValue;

  const MeshGradientPainter({this.animValue = 0});

  @override
  void paint(Canvas canvas, Size size) {
    // Base canvas - using a very subtle gradient for the base instead of solid soft white
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(
      rect,
      Paint()..color = AppColors.canvasSoft,
    );

    // ── Upper mesh atmosphere (signature Stripe vibe) ──────────────
    
    // Blob 1: Amber/Cream — upper-left warm glow
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.1, size.height * 0.1),
        width: size.width * 0.8,
        height: size.height * 0.4,
      ),
      Paint()
        ..color = AppColors.canvasCream.withValues(alpha: 0.8)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 80),
    );

    // Blob 2: Lavender/PrimaryBg — upper-center
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.05),
        width: size.width * 0.7,
        height: size.height * 0.35,
      ),
      Paint()
        ..color = AppColors.primaryBgSub.withValues(alpha: 0.6)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 90),
    );

    // Blob 3: Indigo Primary — upper-right depth
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.9, size.height * 0.08),
        width: size.width * 0.6,
        height: size.height * 0.4,
      ),
      Paint()
        ..color = AppColors.primary.withValues(alpha: 0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 100),
    );

    // Blob 4: Ruby Accent — upper-right edge glow
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 1.0, size.height * 0.02),
        width: size.width * 0.4,
        height: size.height * 0.25,
      ),
      Paint()
        ..color = AppColors.ruby.withValues(alpha: 0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 60),
    );

    // ── Lower mesh balance (extra depth for full-page feel) ──────────────

    // Blob 5: Magenta — soft pink mid-right
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.85, size.height * 0.6),
        width: size.width * 0.5,
        height: size.height * 0.3,
      ),
      Paint()
        ..color = AppColors.magenta.withValues(alpha: 0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 85),
    );

    // Blob 6: Indigo light — bottom-left anchor
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.15, size.height * 0.9),
        width: size.width * 0.6,
        height: size.height * 0.4,
      ),
      Paint()
        ..color = AppColors.primaryLight.withValues(alpha: 0.18)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 110),
    );

    // Blob 7: Lemon/Gold — very subtle warm spot bottom-right
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.75, size.height * 0.95),
        width: size.width * 0.35,
        height: size.height * 0.2,
      ),
      Paint()
        ..color = AppColors.canvasCream.withValues(alpha: 0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 50),
    );
  }

  @override
  bool shouldRepaint(covariant MeshGradientPainter oldDelegate) =>
      oldDelegate.animValue != animValue;
}

/// Background premium dengan Mesh Gradient atmosphere.
///
/// Digunakan di: LoginPage, DashboardPage, dan semua marketing surfaces.
/// Blobs mesh menempati upper-third — sesuai Stripe design language.
class PremiumBackground extends StatelessWidget {
  final Widget child;

  const PremiumBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Mesh gradient layer — occupies full page, atmospheric backdrop
        Positioned.fill(
          child: CustomPaint(
            painter: const MeshGradientPainter(),
          ),
        ),

        // Content layer
        Positioned.fill(child: child),
      ],
    );
  }
}

/// Versi header-only mesh — untuk SliverAppBar backgrounds.
/// Lebih intens di area atas, fade ke bawah.
class HeaderMeshPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Base: deep indigo gradient
    final baseGradient = Paint()
      ..shader = const LinearGradient(
        colors: [AppColors.primary, AppColors.brandDark900],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      baseGradient,
    );

    // Cream highlight — upper-left warm spot
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.1, size.height * 0.2),
        width: size.width * 0.5,
        height: size.height * 0.6,
      ),
      Paint()
        ..color = AppColors.canvasCream.withValues(alpha: 0.12)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40),
    );

    // Magenta accent — upper-right
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.9, size.height * 0.15),
        width: size.width * 0.45,
        height: size.height * 0.5,
      ),
      Paint()
        ..color = AppColors.magenta.withValues(alpha: 0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 35),
    );

    // Ruby glow — right edge
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 1.0, size.height * 0.5),
        width: size.width * 0.3,
        height: size.height * 0.7,
      ),
      Paint()
        ..color = AppColors.ruby.withValues(alpha: 0.1)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30),
    );

    // White shimmer — soft center highlight
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.1),
        width: size.width * 0.6,
        height: size.height * 0.4,
      ),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.06)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 25),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
