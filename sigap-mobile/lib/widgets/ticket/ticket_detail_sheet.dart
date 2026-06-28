import 'package:flutter/material.dart';
import '../../models/ticket_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class TicketDetailSheet extends StatelessWidget {
  final TicketModel ticket;

  const TicketDetailSheet({super.key, required this.ticket});

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      final dt = DateTime.parse(dateStr).toLocal();
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
        'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
      ];
      final monthName = months[dt.month - 1];
      return '${dt.day.toString().padLeft(2, '0')} $monthName ${dt.year}, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = Color(ticket.statusInfo['color'] as int);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 24),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                bottom: MediaQuery.of(context).padding.bottom + 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status & Date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Color(ticket.statusInfo['bgColor'] as int),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          ticket.statusInfo['label'].toString().toUpperCase(),
                          style: AppTextStyles.labelSmall.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        _formatDate(ticket.createdAt),
                        style: AppTextStyles.labelMedium.copyWith(color: AppColors.slate),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Title & Category
                  Text(
                    ticket.judul,
                    style: AppTextStyles.titleLarge.copyWith(fontSize: 22),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.category_rounded, size: 16, color: AppColors.slate),
                      const SizedBox(width: 6),
                      Text(
                        ticket.jenis,
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.slate),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.priority_high_rounded, size: 16, color: AppColors.slate),
                      const SizedBox(width: 6),
                      Text(
                        'Prioritas: ${ticket.priority}',
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.slate),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Info Grid (Reporter & Technician)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.canvasCream,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildInfoItem(
                            Icons.person_outline_rounded,
                            'Pelapor',
                            ticket.reporter ?? 'Anda',
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: AppColors.border,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildInfoItem(
                            Icons.engineering_outlined,
                            'Teknisi',
                            ticket.teknisi ?? 'Belum Ditugaskan',
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  if (ticket.namaAset != null && ticket.namaAset!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.withValues(alpha: 0.1)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.devices_rounded, size: 18, color: Colors.blue),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Aset Terkait: ${ticket.namaAset}',
                              style: AppTextStyles.bodyMedium.copyWith(color: Colors.blue.shade700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Description
                  Text('Deskripsi Keluhan', style: AppTextStyles.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    ticket.deskripsi,
                    style: AppTextStyles.bodyMedium.copyWith(height: 1.5, color: AppColors.inkMute),
                  ),
                  
                  if (ticket.photoUrl != null && ticket.photoUrl!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text('Foto Lampiran', style: AppTextStyles.titleMedium),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        ticket.photoUrl!,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: double.infinity,
                          height: 100,
                          color: AppColors.canvasCream,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.broken_image_rounded, color: AppColors.slate),
                              const SizedBox(height: 8),
                              Text('Gagal memuat foto', style: AppTextStyles.labelSmall.copyWith(color: AppColors.slate)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],

                  if (ticket.tanggapan != null && ticket.tanggapan!.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text('Tanggapan IT', style: AppTextStyles.titleMedium),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.check_circle_outline_rounded, color: AppColors.success, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              ticket.tanggapan!,
                              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.ink),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Tutup', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.slate),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.labelSmall.copyWith(color: AppColors.slate)),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.ink,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
