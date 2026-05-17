import 'package:flutter/material.dart';
import '../../models/asset_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Card yang menampilkan info aset yang akan dipinjam.
class LoanAssetCard extends StatelessWidget {
  final AssetModel? asset;

  const LoanAssetCard({super.key, this.asset});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.subtleShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.computer_rounded, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Aset yang akan dipinjam:',
                  style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 4),
                Text(
                  asset?.nama ?? 'Belum ada aset terpilih',
                  style: AppTextStyles.titleMedium,
                ),
                if (asset != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    asset!.kode,
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
