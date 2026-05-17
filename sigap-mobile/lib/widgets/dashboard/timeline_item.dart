import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class TimelineItem extends StatelessWidget {
  final String title;
  final String desc;
  final String time;
  final bool isLast;
  final bool isDone;

  const TimelineItem({
    super.key,
    required this.title,
    required this.desc,
    required this.time,
    this.isLast = false,
    this.isDone = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDone ? AppColors.accent : AppColors.primary;
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
                border: isDone ? Border.all(color: color.withValues(alpha: 0.3), width: 3) : null,
              ),
            ),
            if (!isLast)
              Container(width: 2, height: 46, color: AppColors.border),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.titleSmall),
              const SizedBox(height: 2),
              Text(desc, style: AppTextStyles.caption),
              const SizedBox(height: 2),
              Text(time, style: AppTextStyles.caption.copyWith(color: AppColors.primary)),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}
