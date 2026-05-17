import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import 'skeleton_loader.dart';
import 'section_header.dart';

/// Centralized repository for all UI Skeletons in the SIGAP Mobile project.
/// Use these placeholders during data fetching to maintain layout stability.

// ── DASHBOARD SKELETONS ───────────────────────────────────────────────

/// Skeleton for the Primary Call-to-Action Banner.
class PrimaryBannerSkeleton extends StatelessWidget {
  const PrimaryBannerSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      child: Container(
        padding: const EdgeInsets.all(AppColors.spaceXl),
        decoration: BoxDecoration(
          color: AppColors.canvas,
          borderRadius: BorderRadius.circular(AppColors.radiusXl),
          border: Border.all(color: AppColors.hairline),
          boxShadow: AppColors.cardShadow,
        ),
        child: const Row(
          children: [
            SkeletonBox(width: 52, height: 52, borderRadius: 8),
            SizedBox(width: AppColors.spaceLg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SkeletonBox(width: 120, height: 20, borderRadius: 4),
                  SizedBox(height: 8),
                  SkeletonBox(width: 180, height: 14, borderRadius: 4),
                ],
              ),
            ),
            SkeletonCircle(size: 34),
          ],
        ),
      ),
    );
  }
}

/// Skeleton for the Statistics Panel (3-column layout).
class StatPanelSkeleton extends StatelessWidget {
  final int count;

  const StatPanelSkeleton({super.key, this.count = 3});

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.canvas,
          borderRadius: BorderRadius.circular(AppColors.radiusXl),
          border: Border.all(color: AppColors.hairline),
          boxShadow: AppColors.floatShadow,
        ),
        padding: const EdgeInsets.symmetric(vertical: AppColors.spaceXl),
        child: Row(
          children: [
            for (int i = 0; i < count; i++) ...[
              const Expanded(child: _SkeletonStatCell()),
              if (i < count - 1)
                Container(width: 1, height: 40, color: AppColors.hairline),
            ],
          ],
        ),
      ),
    );
  }
}

class _SkeletonStatCell extends StatelessWidget {
  const _SkeletonStatCell();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SkeletonCircle(size: 40),
        SizedBox(height: 12),
        SkeletonBox(width: 36, height: 28, borderRadius: 4),
        SizedBox(height: 6),
        SkeletonBox(width: 52, height: 10, borderRadius: 4),
      ],
    );
  }
}

/// Skeleton for Quick Action Items (Row of 3).
class QuickActionSkeleton extends StatelessWidget {
  const QuickActionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      child: Row(
        children: [
          for (int i = 0; i < 3; i++) ...[
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                decoration: BoxDecoration(
                  color: AppColors.canvas,
                  borderRadius: BorderRadius.circular(AppColors.radiusXl),
                  border: Border.all(color: AppColors.hairline),
                  boxShadow: AppColors.cardShadow,
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SkeletonBox(width: 52, height: 52, borderRadius: 8),
                    SizedBox(height: 14),
                    SkeletonBox(width: 40, height: 10, borderRadius: 4),
                  ],
                ),
              ),
            ),
            if (i < 2) const SizedBox(width: 12),
          ],
        ],
      ),
    );
  }
}

/// Skeleton for a generic List Section (e.g., Recent Tickets).
class ListSectionSkeleton extends StatelessWidget {
  final String title;
  final int itemCount;

  const ListSectionSkeleton({
    super.key,
    required this.title,
    this.itemCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: title),
        const SizedBox(height: 10),
        SkeletonLoader(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.canvas,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.hairline),
            ),
            child: Column(
              children: List.generate(itemCount, (i) => Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const SkeletonCircle(size: 40),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SkeletonBox(width: 140, height: 16, borderRadius: 4),
                          SizedBox(height: 8),
                          SkeletonBox(width: 80, height: 12, borderRadius: 4),
                        ],
                      ),
                    ),
                    const SkeletonBox(width: 60, height: 24, borderRadius: AppColors.radiusPill),
                  ],
                ),
              )),
            ),
          ),
        ),
      ],
    );
  }
}
