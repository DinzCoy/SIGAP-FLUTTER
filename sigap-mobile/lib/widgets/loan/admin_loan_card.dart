import 'package:flutter/material.dart';
import '../../models/loan_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class AdminLoanCard extends StatelessWidget {
  final LoanModel loan;
  final Function(LoanModel loan, bool isApprove) onProcess;
  final VoidCallback? onTap;
  final VoidCallback? onReturn;

  const AdminLoanCard({
    super.key,
    required this.loan,
    required this.onProcess,
    this.onTap,
    this.onReturn,
  });

  @override
  Widget build(BuildContext context) {
    final statusInfo = loan.statusInfo;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.floatShadow,
        border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Status badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
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
              Row(
                children: [
                  // Badge jenis transaksi
                  if (loan.isMutasi)
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F3FF),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFF7C3AED).withValues(alpha: 0.4)),
                      ),
                      child: Text(
                        'MUTASI',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: const Color(0xFF7C3AED),
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
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
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                backgroundImage: loan.userPhoto != null ? NetworkImage(loan.userPhoto!) : null,
                child: loan.userPhoto == null
                    ? Icon(Icons.person, color: AppColors.primary)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Peminjam: ${loan.namaUser ?? 'User ID: ${loan.userId}'}',
                      style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (loan.assetOwner != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          'Pemilik Aset: ${loan.assetOwner}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                loan.isMutasi
                    ? Icons.move_to_inbox_rounded
                    : Icons.calendar_today_rounded,
                size: 14,
                color: loan.isMutasi ? const Color(0xFF7C3AED) : AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${loan.isMutasi ? 'Alokasi Permanen' : 'Pinjam'}: ${loan.namaAset}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: loan.isMutasi ? const Color(0xFF7C3AED) : AppColors.textSecondary,
                    fontWeight: loan.isMutasi ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Alasan: ${loan.alasan}',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),

          // Tombol aksi: hanya tampil jika status masih pending
          if (loan.status == 'pending') ...[
            const SizedBox(height: 16),
            Divider(color: AppColors.divider),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => onProcess(loan, false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: BorderSide(color: AppColors.error),
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
                      // Warna berbeda: hijau untuk pinjam, ungu untuk mutasi
                      backgroundColor: loan.isMutasi
                          ? const Color(0xFF7C3AED)
                          : AppColors.success,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(loan.isMutasi ? 'Setujui & Alokasikan' : 'Setujui'),
                  ),
                ),
              ],
            ),
          ] else if (loan.isAktif && loan.isPinjam && onReturn != null) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onReturn,
                icon: const Icon(Icons.assignment_return_rounded, size: 18),
                label: const Text('Kembalikan Aset'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surface,
                  foregroundColor: AppColors.primary,
                  elevation: 0,
                  side: BorderSide(color: AppColors.primary, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ],
      ),
    )));
  }
}
