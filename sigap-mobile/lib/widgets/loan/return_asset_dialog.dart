import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class ReturnAssetDialog extends StatefulWidget {
  const ReturnAssetDialog({super.key});

  @override
  State<ReturnAssetDialog> createState() => _ReturnAssetDialogState();
}

class _ReturnAssetDialogState extends State<ReturnAssetDialog> {
  String _kondisi = 'Baik';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text('Kembalikan Aset', style: AppTextStyles.titleLarge),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pilih kondisi aset saat dikembalikan:',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: DropdownButton<String>(
              isExpanded: true,
              value: _kondisi,
              underline: const SizedBox(),
              items: ['Baik', 'Rusak Ringan', 'Rusak Berat']
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e, style: AppTextStyles.bodyMedium),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _kondisi = v!),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: Text(
            'Batal',
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, _kondisi),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text('Proses Pengembalian', style: AppTextStyles.labelLarge),
        ),
      ],
    );
  }
}
