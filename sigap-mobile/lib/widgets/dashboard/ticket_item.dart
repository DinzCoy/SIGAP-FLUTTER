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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.titleSmall.copyWith(
                      color: AppColors.ink,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            Icon(Icons.person_rounded, size: 14, color: AppColors.primary),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                reporterName,
                                style: AppTextStyles.caption.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.inkSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.primary),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                date,
                                style: AppTextStyles.caption.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.inkSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: StatusBadge(priority, small: true),
            ),
          ],
        ),
      ),
    );
  }
}
