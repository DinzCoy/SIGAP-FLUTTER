import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Widget bagian lampiran foto pada form tiket IT.
/// Menampilkan tombol camera/galeri jika belum ada foto,
/// atau preview foto yang sudah dipilih beserta tombol hapus.
class TicketFotoSection extends StatelessWidget {
  final File? fotoFile;
  final VoidCallback onCamera;
  final VoidCallback onGallery;
  final VoidCallback onRemove;

  const TicketFotoSection({
    super.key,
    required this.fotoFile,
    required this.onCamera,
    required this.onGallery,
    required this.onRemove,
  });

  /// Helper statis untuk memilih gambar dari sumber tertentu.
  static Future<File?> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 75);
    return picked != null ? File(picked.path) : null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: fotoFile == null ? _buildPicker() : _buildPreview(),
    );
  }

  Widget _buildPicker() {
    return Row(
      children: [
        Expanded(
          child: _photoButton(Icons.camera_alt_rounded, 'Ambil Foto', onCamera),
        ),
        Container(width: 1, height: 60, color: AppColors.border),
        Expanded(
          child: _photoButton(
            Icons.photo_library_rounded,
            'Dari Galeri',
            onGallery,
          ),
        ),
      ],
    );
  }

  Widget _buildPreview() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            fotoFile!,
            width: double.infinity,
            height: 180,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 18),
            ),
          ),
        ),
      ],
    );
  }

  Widget _photoButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 28),
            const SizedBox(height: 6),
            Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
