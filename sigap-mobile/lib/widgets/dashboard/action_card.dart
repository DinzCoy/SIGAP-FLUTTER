import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Tombol aksi cepat di dashboard — kartu putih dengan ikon dan deskripsi.
class ActionCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;
  /// Jika true, ikon menggunakan warna aksen oranye SIGAP
  final bool useAccent;

  const ActionCard({
    super.key,
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
    this.useAccent = false,
  });

  @override
  State<ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<ActionCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.useAccent ? AppColors.accent : AppColors.primary;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) { setState(() => _pressed = false); widget.onTap(); },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.canvas, // {colors.canvas}
            borderRadius: BorderRadius.circular(AppColors.radiusLg), // {rounded.lg} = 12px
            boxShadow: AppColors.cardShadow, // Level 1
            border: Border.all(color: AppColors.hairline), // {colors.hairline}
          ),
          child: Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppColors.radiusMd), // {rounded.md} = 8px
                ),
                child: Icon(widget.icon, color: color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.label, 
                      style: AppTextStyles.titleSmall.copyWith(
                        color: AppColors.ink,
                      )
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.subtitle, 
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.inkMute, // {colors.ink-mute}
                      )
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.inkMute, // {colors.ink-mute}
                size: 18
              ),
            ],
          ),
        ),
      ),
    );
  }
}

