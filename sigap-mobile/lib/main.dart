import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'pages/login_page.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();

    // 1. Ambil instance Firebase Messaging
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // 2. Minta izin notif (khusus Android 13+ dan iOS wajib ini)
    await messaging.requestPermission(alert: true, badge: true, sound: true);

    // 3. AMBIL TOKENNYA DISINI
    String? token = await messaging.getToken();

    // Tampilkan di konsol biar bisa kamu copy nanti buat testing di Laravel/cPanel
    debugPrint('========= FCM TOKEN HP INI =========');
    debugPrint(token);
    debugPrint('====================================');

    // 4. Inisialisasi Service Notifikasi (Foreground & Background handler)
    await NotificationService.initialize();

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  } catch (e) {
    debugPrint('Warning: Firebase belum dikonfigurasi. $e');
  }

  runApp(const SigapApp());
}

class SigapApp extends StatelessWidget {
  const SigapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SIGAP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00558D),
          primary: const Color(0xFF00558D),
        ),
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
      ),
      home: const LoginPage(),
    );
  }
}
