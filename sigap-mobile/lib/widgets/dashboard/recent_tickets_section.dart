import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../common/empty_state.dart';
import '../common/section_header.dart';
import '../common/app_skeletons.dart';
import 'ticket_item.dart';

class RecentTicketsSection extends StatelessWidget {
  final List<Map<String, dynamic>> tickets;
  final String title;
  final VoidCallback onSeeAll;
  final bool isLoading;
  final String emptyMessage;

  const RecentTicketsSection({
    super.key,
    required this.tickets,
    required this.title,
    required this.onSeeAll,
    this.isLoading = false,
    this.emptyMessage = 'Belum ada tiket.',
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) return ListSectionSkeleton(title: title);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: title,
          actionLabel: 'Lihat Semua',
          onAction: onSeeAll,
        ),
        const SizedBox(height: 10),
        if (tickets.isEmpty)
          EmptyState(
            icon: Icons.inbox_outlined,
            message: emptyMessage,
          )
        else
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              boxShadow: AppColors.cardShadow,
            ),
            child: Column(
              children: List.generate(
                tickets.length,
                (i) {
                  final isLast = i == tickets.length - 1;
                  return Column(
                    children: [
                      TicketItem.fromMap(tickets[i]),
                      if (!isLast)
                        const Divider(
                          height: 1,
                          indent: 32,
                          endIndent: 16,
                          color: AppColors.divider,
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
      ],
    );
  }


}
