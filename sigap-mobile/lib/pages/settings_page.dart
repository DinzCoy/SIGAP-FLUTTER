import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        title: Text("Pengaturan Aplikasi", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF00558D),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            "Preferensi",
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF00558D),
            ),
          ),
          const SizedBox(height: 10),
          SwitchListTile(
            title: Text("Notifikasi", style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
            subtitle: Text("Terima pemberitahuan tentang status aset", style: GoogleFonts.inter(fontSize: 12)),
            value: _notificationsEnabled,
            activeThumbColor: const Color(0xFF00558D),
            onChanged: (value) {
              setState(() => _notificationsEnabled = value);
            },
          ),
          SwitchListTile(
            title: Text("Mode Gelap (Dark Mode)", style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
            subtitle: Text("Ubah tema aplikasi menjadi gelap", style: GoogleFonts.inter(fontSize: 12)),
            value: _darkModeEnabled,
            activeThumbColor: const Color(0xFF00558D),
            onChanged: (value) {
              setState(() => _darkModeEnabled = value);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Fitur mode gelap sedang dalam pengembangan")),
              );
            },
          ),
          const Divider(height: 30),
          Text(
            "Informasi",
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF00558D),
            ),
          ),
          const SizedBox(height: 10),
          ListTile(
            title: Text("Tentang Aplikasi", style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: "SIGAP",
                applicationVersion: "1.0.0",
                applicationIcon: const Icon(Icons.security, size: 40, color: Color(0xFF00558D)),
                children: [
                  const Text("Sistem Monitoring Terpadu Aset Komputer Badan Pusat Statistik Provinsi Sulawesi Selatan."),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
