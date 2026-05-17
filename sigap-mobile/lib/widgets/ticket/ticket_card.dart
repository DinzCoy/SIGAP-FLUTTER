import 'package:flutter/material.dart';
import '../../models/ticket_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../common/status_badge.dart';

/// Kartu tiket lengkap, biasanya dipakai di Riwayat Tiket
class TicketCard extends StatelessWidget {
  final TicketModel ticket;

  const TicketCard({super.key, required this.ticket});

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      final dt = DateTime.parse(dateStr).toLocal();
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.canvas, // {colors.canvas}
        borderRadius: BorderRadius.circular(AppColors.radiusLg), // {rounded.lg} = 12px
        border: Border.all(color: AppColors.hairline), // {colors.hairline}
        boxShadow: AppColors.cardShadow, // Level 1
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StatusBadge(ticket.statusInfo['label']),
              Text(
                _formatDate(ticket.createdAt),
                style: AppTextStyles.caption.copyWith(color: AppColors.slate),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            ticket.judul,
            style: AppTextStyles.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            ticket.jenis,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            ticket.deskripsi,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.inkMute),
          ),
          if (ticket.namaAset != null && ticket.namaAset!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.canvasSoft,
                borderRadius: BorderRadius.circular(AppColors.radiusSm), // {rounded.sm} = 6px
              ),
              child: Row(
                children: [
                  const Icon(Icons.computer, size: 16, color: AppColors.slate),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      ticket.namaAset!,
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.ink),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (ticket.tanggapan != null && ticket.tanggapan!.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Divider(color: AppColors.hairline),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.reply_rounded,
                  size: 16,
                  color: AppColors.slate,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tanggapan IT:',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.slate,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        ticket.tanggapan!,
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.ink),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
