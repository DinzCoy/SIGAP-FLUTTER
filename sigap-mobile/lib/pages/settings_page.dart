import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengaturan Aplikasi"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            "Preferensi",
            style: AppTextStyles.titleMedium.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: 10),
          SwitchListTile(
            title: Text("Notifikasi", style: AppTextStyles.titleSmall),
            subtitle: Text("Terima pemberitahuan tentang status aset", style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
            value: _notificationsEnabled,
            activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
            activeThumbColor: AppColors.primary,
            onChanged: (value) {
              setState(() => _notificationsEnabled = value);
            },
          ),
          SwitchListTile(
            title: Text("Mode Gelap (Dark Mode)", style: AppTextStyles.titleSmall),
            subtitle: Text("Ubah tema aplikasi menjadi gelap", style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
            value: _darkModeEnabled,
            activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
            activeThumbColor: AppColors.primary,
            onChanged: (value) {
              setState(() => _darkModeEnabled = value);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Fitur mode gelap sedang dalam pengembangan"),
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
          ),
          const Divider(height: 30),
          Text(
            "Informasi",
            style: AppTextStyles.titleMedium.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: 10),
          ListTile(
            title: Text("Tentang Aplikasi", style: AppTextStyles.titleSmall),
            trailing: const Icon(Icons.chevron_right, color: AppColors.textHint),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: "SIGAP",
                applicationVersion: "1.0.0",
                applicationIcon: const Icon(Icons.security_rounded, size: 40, color: AppColors.primary),
                children: [
                  const Text("Sistem Guardian Aset dan Pelayanan IT Badan Pusat Statistik Provinsi Sulawesi Selatan."),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
