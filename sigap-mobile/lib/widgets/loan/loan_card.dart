import 'package:flutter/material.dart';
import '../../models/loan_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class LoanCard extends StatelessWidget {
  final LoanModel loan;
  final VoidCallback? onReturn;
  final VoidCallback? onTap;

  const LoanCard({super.key, required this.loan, this.onReturn, this.onTap});

  @override
  Widget build(BuildContext context) {
    final statusInfo = loan.statusInfo;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section with Status
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Color(
                          statusInfo['bgColor'],
                        ).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Color(
                            statusInfo['color'],
                          ).withValues(alpha: 0.2),
                        ),
                      ),
                      child: Text(
                        statusInfo['label'].toString().toUpperCase(),
                        style: AppTextStyles.labelSmall.copyWith(
                          color: Color(statusInfo['color']),
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (loan.jenis == 'permanen')
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.purple.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.purple.withValues(alpha: 0.15),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.repeat_rounded,
                              size: 12,
                              color: Colors.purple,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'MUTASI',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: Colors.purple,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  loan.namaAset,
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  loan.kodeAset,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.slate,
                    fontFamily: 'Courier', // Tabular-like code feel
                  ),
                ),
              ],
            ),
          ),

          // Metadata Grid (Tabular-ish)
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                if (loan.namaUser != null) ...[
                  _buildUserRow(loan.namaUser!, loan.userPhoto),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(height: 1, color: AppColors.border),
                  ),
                ],
                _buildMetaRow(
                  Icons.calendar_today_rounded,
                  'Periode',
                  loan.isPinjam
                      ? '${_formatShortDate(loan.tanggalMulai)} - ${_formatShortDate(loan.tanggalKembali)}'
                      : 'Diajukan: ${_formatShortDate(loan.createdAt)}',
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(height: 1, color: AppColors.border),
                ),
                _buildMetaRow(
                  Icons.description_outlined,
                  'Keperluan',
                  loan.alasan,
                ),
              ],
            ),
          ),

          if (loan.catatanAdmin != null && loan.catatanAdmin!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.errorBg.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.error.withValues(alpha: 0.1),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 16,
                      color: AppColors.error,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CATATAN ADMIN',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.error,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            loan.catatanAdmin!,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          const SizedBox(height: 16),

          if (loan.isAktif && loan.isPinjam && onReturn != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onReturn,
                  icon: const Icon(Icons.assignment_return_rounded, size: 18),
                  label: Text('Kembalikan Aset'),
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
            )
          else
            const SizedBox(height: 8),
        ],
      ),
    )));
  }

  Widget _buildMetaRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: AppColors.slate),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: AppTextStyles.labelSmall.copyWith(
                  fontSize: 10,
                  color: AppColors.slate,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserRow(String userName, String? userPhoto) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: AppColors.slate.withValues(alpha: 0.2),
          backgroundImage: userPhoto != null ? NetworkImage(userPhoto) : null,
          child: userPhoto == null
              ? Icon(Icons.person, size: 16, color: AppColors.slate)
              : null,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PEMINJAM',
                style: AppTextStyles.labelSmall.copyWith(
                  fontSize: 10,
                  color: AppColors.slate,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                userName,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatShortDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '-';
    try {
      final dt = DateTime.parse(dateStr);
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    } catch (_) {
      return dateStr;
    }
  }
}
