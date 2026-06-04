import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Grid pilihan jenis layanan IT dengan animasi seleksi.
class TicketJenisGrid extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  static const List<String> jenisLayanan = [
    'Service',
    'Troubleshooting',
  ];

  static const Map<String, IconData> jenisIcon = {
    'Service': Icons.build_rounded,
    'Troubleshooting': Icons.computer_rounded,
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
        childAspectRatio: 2.0, // Make it a bit taller since there are only 2 items
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        jenis,
                        style: AppTextStyles.labelLarge.copyWith(
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        jenis == 'Service' ? 'Fisik / Hardware' : 'Software / Jaringan',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: isSelected ? Colors.white70 : AppColors.textSecondary,
                          fontSize: 10,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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
