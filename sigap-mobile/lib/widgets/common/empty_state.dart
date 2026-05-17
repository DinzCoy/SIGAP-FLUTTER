import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'app_button.dart';

/// Tampilan kosong/tidak ada data yang konsisten di seluruh aplikasi.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? subMessage;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.message,
    this.subMessage,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppColors.subtleShadow,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 52, color: AppColors.border),
          const SizedBox(height: 14),
          Text(message, style: AppTextStyles.titleSmall.copyWith(color: AppColors.textSecondary)),
          if (subMessage != null) ...[
            const SizedBox(height: 6),
            Text(
              subMessage!,
              style: AppTextStyles.caption,
              textAlign: TextAlign.center,
            ),
          ],
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 24),
            AppButton.ghost(
              label: actionLabel!,
              onTap: onAction,
            ),
          ],
        ],
      ),
    );
  }
}
