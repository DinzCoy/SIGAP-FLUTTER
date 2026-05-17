import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Grid pilihan jenis layanan IT dengan animasi seleksi.
class TicketJenisGrid extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  static const List<String> jenisLayanan = [
    'Kerusakan Hardware',
    'Masalah Software',
    'Gangguan Jaringan/Internet',
    'Permintaan Instalasi',
    'Pengaturan Akun/Password',
    'Lainnya',
  ];

  static const Map<String, IconData> jenisIcon = {
    'Kerusakan Hardware'        : Icons.build_rounded,
    'Masalah Software'          : Icons.computer_rounded,
    'Gangguan Jaringan/Internet': Icons.wifi_off_rounded,
    'Permintaan Instalasi'      : Icons.install_desktop_rounded,
    'Pengaturan Akun/Password'  : Icons.lock_reset_rounded,
    'Lainnya'                   : Icons.help_outline_rounded,
  };

  const TicketJenisGrid({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.5,
      ),
      itemCount: jenisLayanan.length,
      itemBuilder: (context, index) {
        final jenis = jenisLayanan[index];
        final isSelected = selected == jenis;
        return GestureDetector(
          onTap: () => onSelected(jenis),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: 1.5,
              ),
              boxShadow: isSelected ? AppColors.subtleShadow : [],
            ),
            child: Row(
              children: [
                Icon(
                  jenisIcon[jenis] ?? Icons.help_outline,
                  color: isSelected ? Colors.white : AppColors.primary,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    jenis,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
