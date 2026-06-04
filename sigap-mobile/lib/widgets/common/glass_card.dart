import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Sebuah kontainer berestetika Glassmorphism premium (frosted glass look).
/// Secara adaptif menyesuaikan saturasi blur dan opacity berdasarkan tema aktif (Terang / Gelap).
class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blur;
  final Color? color;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final List<BoxShadow>? shadow;
  final double? width;
  final double? height;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = AppColors.radiusLg,
    this.blur = 16.0,
    this.color,
    this.borderColor,
    this.padding = const EdgeInsets.all(AppColors.spaceLg),
    this.margin,
    this.shadow,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Base background transparan premium adaptif
    final defaultBg = isDark
        ? Colors.white.withValues(
            alpha: 0.04,
          ) // Di layar gelap, sedikit highlight putih transparan
        : Colors.white.withValues(
            alpha: 0.45,
          ); // Di layar terang, buram putih lembut

    // Garis tepian pembias cahaya adaptif
    final defaultBorder = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.white.withValues(alpha: 0.25);

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow:
            shadow ?? (isDark ? AppColors.glassShadow : AppColors.cardShadow),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: color ?? defaultBg,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: borderColor ?? defaultBorder,
                width: 1.0,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
