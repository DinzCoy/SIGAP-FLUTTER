import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../common/app_text_field.dart';

class LoanProcessDialog extends StatefulWidget {
  final bool isApprove;

  const LoanProcessDialog({super.key, required this.isApprove});

  @override
  State<LoanProcessDialog> createState() => _LoanProcessDialogState();
}

class _LoanProcessDialogState extends State<LoanProcessDialog> {
  final _catatanCtrl = TextEditingController();

  @override
  void dispose() {
    _catatanCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        widget.isApprove ? 'Setujui Pengajuan?' : 'Tolak Pengajuan?',
        style: AppTextStyles.titleLarge,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextField(
            label: 'Catatan Admin (Opsional)',
            controller: _catatanCtrl,
            maxLines: 2,
            hint: 'Berikan alasan atau catatan tambahan...',
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
          onPressed: () => Navigator.pop(context, _catatanCtrl.text),
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.isApprove
                ? AppColors.success
                : AppColors.error,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            widget.isApprove ? 'Setujui' : 'Tolak',
            style: AppTextStyles.labelLarge,
          ),
        ),
      ],
    );
  }
}
