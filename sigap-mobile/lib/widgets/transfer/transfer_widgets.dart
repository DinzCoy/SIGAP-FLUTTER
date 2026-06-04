import 'package:flutter/material.dart';
import '../../models/asset_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Banner peringatan mutasi permanen berwarna oranye.
class TransferWarningBanner extends StatelessWidget {
  const TransferWarningBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: AppColors.warning),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Perhatian: Mutasi permanen berarti aset akan dipindah-tangankan sepenuhnya menjadi tanggung jawab Anda, bukan dipinjam sementara.',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.warning),
            ),
          ),
        ],
      ),
    );
  }
}

/// Card info aset yang akan dimutasi secara permanen.
class TransferAssetCard extends StatelessWidget {
  final AssetModel? asset;

  const TransferAssetCard({super.key, this.asset});

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
              color: AppColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.computer, color: AppColors.accent),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Aset yang dimutasi:',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
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
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textHint,
                    ),
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
