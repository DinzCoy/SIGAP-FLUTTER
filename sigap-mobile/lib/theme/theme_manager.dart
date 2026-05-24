import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Pengendali Status Tema Global (State Manager) aplikasi SIGAP.
/// Mengatur penyimpanan preferensi tema pengguna menggunakan SharedPreferences
/// dan memancarkan pemberitahuan perubahan agar antarmuka ter-render ulang secara instan.
class ThemeManager extends ChangeNotifier {
  static final ThemeManager instance = ThemeManager._();
  ThemeManager._();

  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Inisialisasi status tema saat aplikasi pertama kali dijalankan.
  /// Memuat preferensi tersimpan dari sesi sebelumnya.
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey('is_dark_mode')) {
        final isDark = prefs.getBool('is_dark_mode') ?? false;
        _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      } else {
        // Default ke light theme jika preferensi belum diatur manual
        _themeMode = ThemeMode.light;
      }
    } catch (e) {
      debugPrint('Error memuat preferensi tema: $e');
      _themeMode = ThemeMode.light;
    }
    notifyListeners();
  }

  /// Mengubah tema aktif aplikasi secara dinamis (Light <-> Dark).
  Future<void> toggleTheme(bool enableDark) async {
    _themeMode = enableDark ? ThemeMode.dark : ThemeMode.light;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_dark_mode', enableDark);
    } catch (e) {
      debugPrint('Error menyimpan preferensi tema: $e');
    }
    
    notifyListeners();
  }

  /// Mengatur ulang tema ke setelan sistem (digunakan saat logout/clearing).
  void resetTheme() {
    _themeMode = ThemeMode.system;
    notifyListeners();
  }
}
