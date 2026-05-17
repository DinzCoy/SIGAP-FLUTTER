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
      title:        map['title']         as String? ?? '-',
      reporterName: map['reporter_name'] as String? ?? '-',
      date:         map['date']          as String? ?? '-',
      status:       map['status']        as String? ?? '',
      priority:     map['priority']      as String? ?? 'Rendah',
      onTap:        onTap,
    );
  }

  Color get _barColor {
    final s = status.toLowerCase();
    if (s.contains('progress'))  return AppColors.primary;
    if (s.contains('menunggu'))  return AppColors.warning;
    if (s.contains('selesai'))   return AppColors.success;
    return AppColors.border;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center, // Aligned center for a cleaner tabular look
          children: [
            // Softer status bar
            Container(
              width: 4, height: 40,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: _barColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Konten tengah
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.titleSmall.copyWith(
                      color: AppColors.ink,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.person_rounded,
                          size: 14, color: AppColors.slate),
                      const SizedBox(width: 4),
                      Text(
                        reporterName, 
                        style: AppTextStyles.caption.copyWith(color: AppColors.slate),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.schedule_rounded,
                          size: 14, color: AppColors.slate),
                      const SizedBox(width: 4),
                      Text(
                        date, 
                        style: AppTextStyles.caption.copyWith(color: AppColors.slate),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Badge prioritas
            StatusBadge(priority, small: true),
          ],
        ),
      ),
    );
  }
}

