import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class DashboardBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavigationBarItem> items;

  const DashboardBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> leftItems = [];
    List<Widget> rightItems = [];

    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      final isSelected = currentIndex == i;
      final color = isSelected ? AppColors.primary : AppColors.textSecondary;
      final icon = isSelected ? item.activeIcon : item.icon;

      Widget navItem = Expanded(
        child: InkWell(
          onTap: () => onTap(i),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconTheme(
                data: IconThemeData(color: color, size: 24),
                child: icon,
              ),
              const SizedBox(height: 4),
              Text(
                item.label ?? '',
                style: AppTextStyles.labelSmall.copyWith(
                  color: color,
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      );

      if (i < items.length / 2) {
        leftItems.add(navItem);
      } else {
        rightItems.add(navItem);
      }
    }

    return BottomAppBar(
      color: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      shadowColor: Colors.black.withValues(alpha: 0.2),
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      padding: EdgeInsets.zero,
      height: 70, // Fixed height for standard bottom bar
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: leftItems,
            ),
          ),
          const SizedBox(width: 56), // Space for the FAB
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: rightItems,
            ),
          ),
        ],
      ),
    );
  }
}
