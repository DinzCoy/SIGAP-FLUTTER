import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Panel statistik dalam satu card putih — {card-dashboard-mockup} style.
///
/// Setiap angka WAJIB menggunakan tabular figures [FontFeature.tabularFigures()]
/// sesuai DESIGN.md: "Any cell rendering currency, transaction amounts, or numeric
/// counts uses font-feature-settings: 'tnum'".
class StatPanel extends StatelessWidget {
  final List<StatItem> items;

  const StatPanel({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.canvas, // {colors.canvas}
        borderRadius: BorderRadius.circular(
          AppColors.radiusXl,
        ), // {rounded.xl} = 16px
        border: Border.all(color: AppColors.hairline), // {colors.hairline}
        boxShadow: AppColors.floatShadow, // Level 2
      ),
      padding: const EdgeInsets.symmetric(
        vertical: AppColors.spaceXl, // 24px — {spacing.xl}
      ),
      child: Row(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            Expanded(child: _StatCell(item: items[i])),
            if (i < items.length - 1)
              Container(
                width: 1,
                height: 40,
                color: AppColors.hairline, // {colors.hairline}
              ),
          ],
        ],
      ),
    );
  }
}

class StatItem {
  final String value;
  final String label;
  final String? subtitle;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback? onTap;

  StatItem({
    required this.value,
    required this.label,
    this.subtitle,
    required this.icon,
    this.iconColor,
    this.onTap,
  });
}

class _StatCell extends StatelessWidget {
  final StatItem item;

  const _StatCell({required this.item});

  @override
  Widget build(BuildContext context) {
    final effectiveColor = item.iconColor ?? AppColors.primary;
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: effectiveColor.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(item.icon, color: effectiveColor, size: 18),
        ),
        const SizedBox(height: AppColors.spaceMd),
        Text(
          item.value,
          style: AppTextStyles.statNumber.copyWith(color: AppColors.ink),
        ),
        const SizedBox(height: AppColors.spaceXs),
        Text(
          item.label.toUpperCase(),
          style: AppTextStyles.microCap.copyWith(
            color: AppColors.inkMute,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (item.subtitle != null) ...[
          const SizedBox(height: AppColors.spaceXs),
          Text(
            item.subtitle!,
            style: AppTextStyles.caption.copyWith(color: AppColors.inkMute),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );

    if (item.onTap != null) {
      return InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(12),
        child: content,
      );
    }
    return content;
  }
}

/// Versi loading skeleton untuk StatPanel
