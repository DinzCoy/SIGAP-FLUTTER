import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class TicketPrioritySelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  const TicketPrioritySelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  static const List<Map<String, String>> priorities = [
    {
      'value': 'Rendah',
      'emoji': '🟢',
      'label': 'Rendah',
      'sub': 'Masih bisa dipakai'
    },
    {
      'value': 'Sedang',
      'emoji': '🟡',
      'label': 'Sedang',
      'sub': 'Ganggu aktivitas'
    },
    {
      'value': 'Tinggi',
      'emoji': '🔴',
      'label': 'Tinggi',
      'sub': 'Mati total / Urgent'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: priorities.map((p) {
        final isSelected = selected == p['value'];
        return Expanded(
          child: GestureDetector(
            onTap: () => onSelected(p['value']!),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(
                right: p['value'] == 'Tinggi' ? 0 : 8,
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.infoBg : AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                children: [
                  Text(p['emoji']!, style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 4),
                  Text(
                    p['label']!,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    p['sub']!,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 9,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
