// lib/widgets/ticket/ticket_photo_viewer.dart
// Widget untuk menampilkan thumbnail foto kerusakan di kartu tiket,
// dengan kemampuan diklik untuk melihat foto penuh (full-screen).

import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Thumbnail foto yang bisa diklik untuk membuka tampilan layar penuh.
class TicketPhotoThumbnail extends StatelessWidget {
  final String photoUrl;

  const TicketPhotoThumbnail({super.key, required this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showFullScreen(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppColors.radiusMd),
        child: Stack(
          children: [
            Image.network(
              photoUrl,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 160,
                  color: AppColors.canvasSoft,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stack) => Container(
                height: 80,
                color: AppColors.canvasSoft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.broken_image_outlined, color: AppColors.slate, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Gagal memuat foto',
                      style: AppTextStyles.caption.copyWith(color: AppColors.slate),
                    ),
                  ],
                ),
              ),
            ),
            // Overlay ikon zoom di pojok kanan bawah
            Positioned(
              right: 8,
              bottom: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.zoom_in_rounded, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFullScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _FullScreenPhotoPage(photoUrl: photoUrl),
      ),
    );
  }
}

/// Halaman layar penuh untuk melihat foto secara detail.
class _FullScreenPhotoPage extends StatelessWidget {
  final String photoUrl;
  const _FullScreenPhotoPage({required this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text(
          'Foto Kerusakan',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 0.5,
          maxScale: 4.0,
          child: Image.network(
            photoUrl,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            },
            errorBuilder: (context, error, stack) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.broken_image_outlined, color: Colors.white54, size: 48),
                const SizedBox(height: 12),
                Text(
                  'Gagal memuat foto',
                  style: AppTextStyles.bodyMedium.copyWith(color: Colors.white54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
