// lib/widgets/ticket/admin_ticket_card.dart
// Kartu tiket untuk tampilan Admin dengan tombol ubah status

import 'package:flutter/material.dart';
import '../../models/ticket_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'ticket_photo_viewer.dart';

class AdminTicketCard extends StatelessWidget {
  final TicketModel ticket;
  final VoidCallback onUpdateStatus;

  const AdminTicketCard({
    super.key,
    required this.ticket,
    required this.onUpdateStatus,
  });

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '-';
    try {
      final dt = DateTime.parse(dateStr).toLocal();
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}  '
          '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return dateStr;
    }
  }

  Color _priorityColor(String p) {
    switch (p) {
      case 'Tinggi':
        return AppColors.error;
      case 'Sedang':
        return const Color(0xFFF59E0B);
      default:
        return AppColors.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusInfo = ticket.statusInfo;
    final Color statusColor = Color(statusInfo['color'] as int);
    final Color statusBg   = Color(statusInfo['bgColor'] as int);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.canvas,
        borderRadius: BorderRadius.circular(AppColors.radiusLg),
        border: Border.all(color: AppColors.hairline),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: statusBg,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor.withAlpha(80)),
                  ),
                  child: Text(
                    statusInfo['label'] as String,
                    style: AppTextStyles.caption.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _priorityColor(ticket.priority).withAlpha(20),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _priorityColor(ticket.priority).withAlpha(80)),
                  ),
                  child: Text(
                    ticket.priority,
                    style: AppTextStyles.caption.copyWith(
                      color: _priorityColor(ticket.priority),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  '#${ticket.id}',
                  style: AppTextStyles.caption.copyWith(color: AppColors.slate),
                ),
              ],
            ),
          ),

          // ── Body ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ticket.judul,
                  style: AppTextStyles.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      ticket.jenis == 'Insiden'
                          ? Icons.warning_amber_rounded
                          : Icons.build_outlined,
                      size: 13,
                      color: AppColors.slate,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      ticket.jenis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  ticket.deskripsi,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.inkMute),
                ),
                const SizedBox(height: 12),

                // ── Meta info ──────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.canvasSoft,
                    borderRadius: BorderRadius.circular(AppColors.radiusSm),
                  ),
                  child: Column(
                    children: [
                      if (ticket.reporter != null && ticket.reporter!.isNotEmpty)
                        _metaRow(Icons.person_outline, 'Pelapor', ticket.reporter!),
                      if (ticket.namaAset != null && ticket.namaAset!.isNotEmpty)
                        _metaRow(Icons.computer_outlined, 'Aset', ticket.namaAset!),
                      if (ticket.teknisi != null && ticket.teknisi!.isNotEmpty)
                        _metaRow(Icons.engineering_outlined, 'Teknisi', ticket.teknisi!),
                      _metaRow(Icons.schedule, 'Masuk', _formatDate(ticket.createdAt)),
                    ],
                  ),
                ),

                // ── Foto Kerusakan ─────────────────────────────
                if (ticket.photoUrl != null && ticket.photoUrl!.isNotEmpty) ...[
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.photo_camera_outlined, size: 14, color: AppColors.slate),
                      const SizedBox(width: 6),
                      Text(
                        'Foto Kerusakan:',
                        style: AppTextStyles.labelSmall.copyWith(color: AppColors.slate),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TicketPhotoThumbnail(photoUrl: ticket.photoUrl!),
                ],

                // ── Aksi ──────────────────────────────────────
                if (ticket.isActive) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: onUpdateStatus,
                      icon: const Icon(Icons.edit_note_rounded, size: 18),
                      label: Text('Update Status'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppColors.radiusMd),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
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

  Widget _metaRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14, color: AppColors.slate),
          const SizedBox(width: 6),
          Text(
            '$label: ',
            style: AppTextStyles.caption.copyWith(color: AppColors.slate),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.caption.copyWith(color: AppColors.ink),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
