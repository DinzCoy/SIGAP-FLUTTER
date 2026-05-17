import 'package:flutter/material.dart';
import '../../models/loan_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class AdminLoanCard extends StatelessWidget {
  final LoanModel loan;
  final Function(LoanModel loan, bool isApprove) onProcess;

  const AdminLoanCard({
    super.key,
    required this.loan,
    required this.onProcess,
  });

  @override
  Widget build(BuildContext context) {
    final statusInfo = loan.statusInfo;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(statusInfo['bgColor']).withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: Color(statusInfo['color']).withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  statusInfo['label'],
                  style: AppTextStyles.labelMedium.copyWith(
                    color: Color(statusInfo['color']),
                  ),
                ),
              ),
              Text(
                '#${loan.id}',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            loan.namaUser ?? 'User ID: ${loan.userId}',
            style: AppTextStyles.titleMedium,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                loan.jenis == 'permanen'
                    ? Icons.transfer_within_a_station_rounded
                    : Icons.calendar_today_rounded,
                size: 14,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${loan.jenis == 'permanen' ? 'Mutasi' : 'Pinjam'}: ${loan.namaAset}',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Alasan: ${loan.alasan}',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
          ),
          
          if (loan.status == 'menunggu_persetujuan') ...[
            const SizedBox(height: 16),
            const Divider(color: AppColors.divider),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => onProcess(loan, false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Tolak'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => onProcess(loan, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Setujui'),
                  ),
                ),
              ],
            ),
          ]
        ],
      ),
    );
  }
}
