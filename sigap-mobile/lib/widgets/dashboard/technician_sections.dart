import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../common/section_header.dart';
import '../common/status_badge.dart';
import 'task_item.dart';
import 'timeline_item.dart';

/// Section untuk daftar aktivitas tugas teknisi terakhir.
class TaskActivitySection extends StatelessWidget {
  final List<TaskItem> tasks;
  final VoidCallback onSeeAll;

  const TaskActivitySection({
    super.key,
    required this.tasks,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Aktivitas Terakhir',
          actionLabel: 'Lihat Semua',
          onAction: onSeeAll,
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            boxShadow: AppColors.cardShadow,
          ),
          child: Column(
            children: List.generate(tasks.length, (i) {
              final isLast = i == tasks.length - 1;
              return Column(
                children: [
                  tasks[i],
                  if (!isLast)
                    const Divider(
                      height: 1,
                      indent: 32,
                      endIndent: 16,
                      color: AppColors.divider,
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

/// Section untuk alur perbaikan terakhir dalam bentuk timeline.
/// [items] berasal dari key `repair_timeline` di response API teknisi.
class RepairTimelineSection extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const RepairTimelineSection({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Alur Perbaikan Terakhir'),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            boxShadow: AppColors.cardShadow,
          ),
          child: items.isEmpty
              ? Row(
                  children: [
                    const Icon(Icons.history_rounded,
                        size: 20, color: AppColors.textSecondary),
                    const SizedBox(width: 12),
                    Text(
                      'Belum ada riwayat perbaikan',
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: items.map((item) {
                    return TimelineItem(
                      title: item['title'] ?? '',
                      desc: item['desc'] ?? '',
                      time: item['time'] ?? '',
                      isDone: item['is_done'] == true,
                      isLast: item['is_last'] == true,
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }
}


/// Section untuk visualisasi denah/lokasi kantor sederhana.
class OfficeMapSection extends StatelessWidget {
  const OfficeMapSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Cek Lokasi Perangkat'),
        const SizedBox(height: 10),
        Container(
          height: 160,
          decoration: BoxDecoration(
            color: AppColors.border.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.map_outlined, size: 40, color: AppColors.textSecondary),
                const SizedBox(height: 8),
                Text(
                  'Denah Kantor SIGAP',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 12),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StatusBadge('Ruang Rapat 3A'),
                    SizedBox(width: 8),
                    StatusBadge('Bagian Umum'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
