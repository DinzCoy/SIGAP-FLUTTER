import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class RoleSelectionSheet extends StatelessWidget {
  final List<Map<String, dynamic>> roles;
  final Function(int roleId, String roleName) onRoleSelected;

  const RoleSelectionSheet({
    super.key,
    required this.roles,
    required this.onRoleSelected,
  });

  static Future<void> show(
    BuildContext context, {
    required List<Map<String, dynamic>> roles,
    required Function(int roleId, String roleName) onRoleSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => RoleSelectionSheet(
        roles: roles,
        onRoleSelected: onRoleSelected,
      ),
    );
  }

  Map<String, dynamic> _getRoleStyle(int roleId) {
    switch (roleId) {
      case 2: // Administrator
        return {
          'icon': Icons.admin_panel_settings_rounded,
          'color': const Color(0xFFEF4444),
          'bgColor': const Color(0xFFFEF2F2),
          'desc': 'Kelola sistem, aset, tiket aduan, dan semua pengguna.',
        };
      case 4: // Pengelola Barang
        return {
          'icon': Icons.inventory_2_rounded,
          'color': const Color(0xFF3B82F6),
          'bgColor': const Color(0xFFEFF6FF),
          'desc': 'Kelola master katalog barang, status, dan peminjaman.',
        };
      case 7: // Ketua Tim
        return {
          'icon': Icons.supervisor_account_rounded,
          'color': const Color(0xFF8B5CF6),
          'bgColor': const Color(0xFFF5F3FF),
          'desc': 'Monitoring dashboard tim dan delegasikan tugas pemeliharaan.',
        };
      case 3: // Teknisi
        return {
          'icon': Icons.build_circle_rounded,
          'color': const Color(0xFFF59E0B),
          'bgColor': const Color(0xFFFEF3C7),
          'desc': 'Kerjakan dan selesaikan tiket aduan serta pemeliharaan aset.',
        };
      case 1: // Pimpinan
        return {
          'icon': Icons.pie_chart_rounded,
          'color': const Color(0xFF0D9488),
          'bgColor': const Color(0xFFF0FDF4),
          'desc': 'Lihat grafik pelaporan, statistik aset, dan ringkasan data.',
        };
      case 5: // Pengelola Ruangan
        return {
          'icon': Icons.meeting_room_rounded,
          'color': const Color(0xFF0EA5E9),
          'bgColor': const Color(0xFFF0F9FF),
          'desc': 'Awasi dan laporkan kondisi aset di ruangan penugasan.',
        };
      case 6: // User
      default:
        return {
          'icon': Icons.person_rounded,
          'color': const Color(0xFF6B7280),
          'bgColor': const Color(0xFFF3F4F6),
          'desc': 'Pinjam aset operasional dan buat aduan kerusakan barang.',
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      padding: EdgeInsets.fromLTRB(24, 20, 24, 20 + bottomPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Title & Subtitle
          Text(
            'Pilih Role Akses',
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.ink,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Akun Anda terdaftar dengan beberapa hak akses. Pilih salah satu untuk melanjutkan masuk ke dashboard.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.inkMute,
            ),
          ),
          const SizedBox(height: 24),

          // Role List
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: roles.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final role = roles[index];
                final roleId = int.tryParse(role['id'].toString()) ?? 6;
                final roleName = role['name'].toString();
                final style = _getRoleStyle(roleId);

                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      onRoleSelected(roleId, roleName);
                    },
                    borderRadius: BorderRadius.circular(18),
                    child: Ink(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: AppColors.border,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: style['color'].withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Custom styled icon container
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: style['bgColor'],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              style['icon'],
                              color: style['color'],
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Text Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  roleName,
                                  style: AppTextStyles.titleMedium.copyWith(
                                    color: AppColors.ink,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  style['desc'],
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.inkMute,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Arrow indicator
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.only(top: 12),
                              child: Icon(
                                Icons.chevron_right_rounded,
                                color: AppColors.textHint,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
