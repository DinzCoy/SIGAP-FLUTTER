import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/notification_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Satu item notifikasi dalam list — menampilkan foto/ikon, judul, body, waktu,
/// dan dot indikator jika belum dibaca.
class NotificationItem extends StatelessWidget {
  final NotificationModel notif;
  final VoidCallback onTap;

  const NotificationItem({super.key, required this.notif, required this.onTap});

  static IconData _getIcon(String type) {
    switch (type) {
      case 'ticket':
        return Icons.support_agent;
      case 'loan':
      case 'permintaan_peminjaman':
      case 'peminjaman_disetujui':
      case 'peminjaman_ditolak':
      case 'peminjaman_dikembalikan':
        return Icons.assignment_turned_in;
      case 'asset':
      case 'mutasi_aset':
        return Icons.computer;
      default:
        return Icons.notifications;
    }
  }

  static Color _getColor(String type) {
    switch (type) {
      case 'ticket':
        return AppColors.accent;
      case 'loan':
      case 'permintaan_peminjaman':
      case 'peminjaman_disetujui':
      case 'peminjaman_ditolak':
      case 'peminjaman_dikembalikan':
        return AppColors.info;
      case 'asset':
      case 'mutasi_aset':
        return AppColors.primaryLight;
      default:
        return AppColors.primary;
    }
  }

  static String _formatTime(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr).toLocal();
      return DateFormat('dd MMM yyyy, HH:mm').format(dt);
    } catch (_) {
      return dateStr;
    }
  }

  /// Widget avatar: foto profil jika ada, fallback ke icon berwarna
  Widget _buildAvatar(Color color) {
    if (notif.userPhoto != null && notif.userPhoto!.isNotEmpty) {
      return CircleAvatar(
        radius: 22,
        backgroundColor: color.withValues(alpha: 0.1),
        backgroundImage: NetworkImage(notif.userPhoto!),
        onBackgroundImageError: (e, s) {},
        child: null,
      );
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(_getIcon(notif.type), color: color, size: 22),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor(notif.type);

    return InkWell(
      onTap: onTap,
      child: Container(
        color: notif.isRead
            ? Colors.transparent
            : AppColors.primary.withValues(alpha: 0.05),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar: foto profil atau ikon
            _buildAvatar(color),
            const SizedBox(width: 16),

            // Konten
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notif.title,
                    style: AppTextStyles.titleSmall.copyWith(
                      fontWeight: notif.isRead
                          ? FontWeight.w500
                          : FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notif.body,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatTime(notif.createdAt),
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),

            // Dot belum dibaca
            if (!notif.isRead)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
