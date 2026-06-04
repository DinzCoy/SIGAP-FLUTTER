import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'pages/splash_page.dart';
import 'services/notification_service.dart';
import 'theme/app_theme.dart';
import 'theme/theme_manager.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi format tanggal Indonesia
  await initializeDateFormatting('id_ID', null);

  // Inisialisasi ThemeManager sebelum menjalankan aplikasi
  await ThemeManager.instance.initialize();

  try {
    await Firebase.initializeApp();

    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(alert: true, badge: true, sound: true);

    final token = await messaging.getToken();
    debugPrint('========= FCM TOKEN =========');
    debugPrint(token);
    debugPrint('=============================');

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
    return ListenableBuilder(
      listenable: ThemeManager.instance,
      builder: (context, _) {
        return MaterialApp(
          key: ValueKey(ThemeManager.instance.themeMode),
          navigatorKey: navigatorKey,
          title: 'SIGAP',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark, // Theme Gelap Adaptif
          themeMode: ThemeManager.instance.themeMode,
          home: const SplashPage(),
        );
      },
    );
  }
}
