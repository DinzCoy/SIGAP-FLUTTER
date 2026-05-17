import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Tombol utama aplikasi SIGAP.
/// Gunakan [AppButton.primary] untuk aksi utama,
/// [AppButton.secondary] untuk aksi sekunder,
/// [AppButton.accent] untuk aksi aksen oranye BPS.
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool fullWidth;
  final double height;
  final Widget? icon;
  final _ButtonVariant _variant;

  const AppButton.primary({
    super.key,
    required this.label,
    this.onTap,
    this.isLoading = false,
    this.fullWidth = true,
    this.height = 52,
    this.icon,
  }) : _variant = _ButtonVariant.primary;

  const AppButton.secondary({
    super.key,
    required this.label,
    this.onTap,
    this.isLoading = false,
    this.fullWidth = true,
    this.height = 52,
    this.icon,
  }) : _variant = _ButtonVariant.secondary;

  const AppButton.accent({
    super.key,
    required this.label,
    this.onTap,
    this.isLoading = false,
    this.fullWidth = true,
    this.height = 52,
    this.icon,
  }) : _variant = _ButtonVariant.accent;

  const AppButton.ghost({
    super.key,
    required this.label,
    this.onTap,
    this.isLoading = false,
    this.fullWidth = false,
    this.height = 44,
    this.icon,
  }) : _variant = _ButtonVariant.ghost;

  /// Dark variant — {button-on-dark} untuk surface navy/dark
  const AppButton.dark({
    super.key,
    required this.label,
    this.onTap,
    this.isLoading = false,
    this.fullWidth = true,
    this.height = 44,
    this.icon,
  }) : _variant = _ButtonVariant.dark;

  @override
  Widget build(BuildContext context) {
    final bg = switch (_variant) {
      _ButtonVariant.primary   => AppColors.primary,
      _ButtonVariant.secondary => Colors.transparent,
      _ButtonVariant.accent    => AppColors.accent,
      _ButtonVariant.ghost     => Colors.transparent,
      _ButtonVariant.dark      => AppColors.brandDark900,
    };
    
    final gradient = switch (_variant) {
      _ButtonVariant.primary   => AppColors.primaryGradient,
      _ButtonVariant.accent    => AppColors.accentGradient,
      _ => null,
    };

    final fg = switch (_variant) {
      _ButtonVariant.primary   => Colors.white,
      _ButtonVariant.secondary => AppColors.primary,
      _ButtonVariant.accent    => Colors.white,
      _ButtonVariant.ghost     => AppColors.primary,
      _ButtonVariant.dark      => Colors.white,
    };
    
    final border = _variant == _ButtonVariant.secondary
        ? BorderSide(color: AppColors.primary, width: 1.5)
        : BorderSide.none;

    // {rounded.pill} = 9999px — semua button WAJIB pill shape (DESIGN.md)
    const borderRadius = BorderRadius.only(
      topLeft: Radius.circular(9999),
      topRight: Radius.circular(9999),
      bottomLeft: Radius.circular(9999),
      bottomRight: Radius.circular(9999),
    );

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: borderRadius,
          boxShadow: _variant == _ButtonVariant.primary || _variant == _ButtonVariant.accent
              ? [
                  BoxShadow(
                    color: (gradient?.colors.last ?? bg).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: gradient != null ? Colors.transparent : bg,
            foregroundColor: fg,
            shadowColor: Colors.transparent,
            elevation: 0,
            side: border,
            shape: const StadiumBorder(), // pill shape
          ),
          child: isLoading
              ? SizedBox(
                  width: 20, height: 20,
                  child: CircularProgressIndicator(
                    color: fg, strokeWidth: 2.5,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[icon!, const SizedBox(width: 8)],
                    Text(label, style: AppTextStyles.buttonMd.copyWith(
                      color: fg,
                    )),
                  ],
                ),
        ),
      ),
    );
  }
}

enum _ButtonVariant { primary, secondary, accent, ghost, dark }

