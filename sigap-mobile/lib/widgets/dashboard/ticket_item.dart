import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../common/status_badge.dart';

/// Item tiket dalam daftar — bar warna kiri + judul + meta + badge prioritas.
/// Dipakai di dashboard (ringkasan) dan halaman tiket lengkap.
class TicketItem extends StatelessWidget {
  final String title;
  final String reporterName;
  final String date;
  final String status;
  final String priority;
  final VoidCallback? onTap;

  const TicketItem({
    super.key,
    required this.title,
    required this.reporterName,
    required this.date,
    required this.status,
    required this.priority,
    this.onTap,
  });

  /// Buat dari Map JSON API
  factory TicketItem.fromMap(Map<String, dynamic> map, {VoidCallback? onTap}) {
    return TicketItem(
      title: map['title'] as String? ?? '-',
      reporterName: map['reporter_name'] as String? ?? '-',
      date: map['date'] as String? ?? '-',
      status: map['status'] as String? ?? '',
      priority: map['priority'] as String? ?? 'Rendah',
      onTap: onTap,
    );
  }



  @override
  Widget build(BuildContext context) {
    // Tentukan warna ikon berdasarkan prioritas
    Color iconColor = AppColors.primary;
    if (priority.toLowerCase() == 'tinggi') iconColor = AppColors.error;
    if (priority.toLowerCase() == 'sedang') iconColor = AppColors.warning;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Leading Icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.assignment_outlined,
                size: 20,
                color: iconColor,
              ),
            ),
            const SizedBox(width: 16),
            
            // Text Content (Title & Meta)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.titleSmall.copyWith(
                      color: AppColors.ink,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.person_rounded, size: 12, color: AppColors.inkSecondary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          reporterName,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.inkSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.calendar_today_rounded, size: 12, color: AppColors.inkSecondary),
                      const SizedBox(width: 4),
                      Text(
                        date,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.inkSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            
            // Trailing Badge
            StatusBadge(priority, small: true),
          ],
        ),
      ),
    );
  }
}
