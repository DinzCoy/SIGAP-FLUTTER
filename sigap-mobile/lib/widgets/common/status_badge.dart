import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Badge status & prioritas yang konsisten di seluruh aplikasi.
/// Warna otomatis berdasarkan nilai [label].
class StatusBadge extends StatelessWidget {
  final String label;
  final bool small;

  const StatusBadge(this.label, {super.key, this.small = false});
  const StatusBadge.small(this.label, {super.key}) : small = true;

  @override
  Widget build(BuildContext context) {
    final (fg, bg) = _resolveColor(label);
    final px = small ? 8.0 : 10.0;
    final py = small ? 2.5 : 4.5;
    final fs = small ? 9.0 : 10.0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: px, vertical: py),
      decoration: BoxDecoration(
        color: bg, 
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: fg.withValues(alpha: 0.1)),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTextStyles.labelSmall.copyWith(
          color: fg, 
          fontSize: fs,
          letterSpacing: 0.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }


  static (Color fg, Color bg) _resolveColor(String label) {
    final l = label.toLowerCase();
    // Prioritas
    if (l == 'tinggi')          return (AppColors.error,   AppColors.errorBg);
    if (l == 'sedang')          return (AppColors.warning,  AppColors.warningBg);
    if (l == 'rendah')          return (AppColors.success,  AppColors.successBg);
    // Status tiket / pinjaman
    if (l.contains('selesai'))      return (AppColors.success,  AppColors.successBg);
    if (l.contains('progress'))     return (AppColors.primary,  AppColors.infoBg);
    if (l.contains('menunggu'))     return (AppColors.warning,  AppColors.warningBg);
    if (l.contains('ditolak'))      return (AppColors.error,    AppColors.errorBg);
    if (l.contains('disetujui'))    return (AppColors.success,  AppColors.successBg);
    if (l.contains('dipinjam'))     return (AppColors.accent,   const Color(0xFFFFF0E0));
    if (l.contains('dikembalikan')) return (AppColors.info,     AppColors.infoBg);
    if (l == 'pending')             return (AppColors.warning,  AppColors.warningBg);
    if (l == 'dikerjakan')          return (AppColors.primary,  AppColors.infoBg);
    if (l == 'batal' || l.contains('dibatal')) return (AppColors.error, AppColors.errorBg);
    // Default
    return (AppColors.textSecondary, AppColors.background);
  }
}
