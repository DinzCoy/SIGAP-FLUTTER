// lib/services/notification_service.dart
// Service untuk menangani Push Notification (FCM) dan Local Notification

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_client.dart';
import 'dart:convert';

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static bool _isInitialized = false;

  /// Inisialisasi Firebase Messaging dan Local Notification
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // 1. Request permission (untuk iOS dan Android 13+)
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus != AuthorizationStatus.authorized) {
        debugPrint('User declined or has not accepted permission');
        return;
      }

      // 2. Setup Local Notifications untuk foreground
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
          
      // Untuk iOS bisa tambahkan DarwinInitializationSettings jika diperlukan
      const InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
      );

      await _localNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (details) {
          // Handle saat notifikasi diklik
          debugPrint('Notifikasi diklik: ${details.payload}');
        },
      );

      // 3. Konfigurasi channel untuk Android 8.0+
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'sigap_high_importance_channel', // id
        'SIGAP Notifications', // name
        description: 'Notifikasi penting untuk SIGAP', // description
        importance: Importance.high,
      );

      await _localNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      // 4. Handle pesan saat aplikasi di foreground
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('Got a message whilst in the foreground!');
        debugPrint('Message data: ${message.data}');

        if (message.notification != null) {
          debugPrint('Message also contained a notification: ${message.notification}');
          _showLocalNotification(message, channel);
        }
      });

      // 5. Handle pesan saat aplikasi dibuka dari background/terminated via notifikasi
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint('Aplikasi dibuka dari notifikasi: ${message.messageId}');
        // Rencana: Navigasi ke halaman spesifik berdasarkan payload message.data
      });

      // 6. Dapatkan token FCM dan simpan ke server jika user sudah login
      await _updateFCMToken();

      // Update token jika refresh
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        _sendTokenToServer(newToken);
      });

      _isInitialized = true;
    } catch (e) {
      debugPrint('Gagal inisialisasi notifikasi: $e');
    }
  }

  /// Menampilkan notifikasi lokal saat aplikasi di foreground
  static void _showLocalNotification(RemoteMessage message, AndroidNotificationChannel channel) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      _localNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: '@mipmap/ic_launcher',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        payload: jsonEncode(message.data),
      );
    }
  }

  /// Mendapatkan FCM token dan mengirimkannya ke Laravel
  static Future<void> _updateFCMToken() async {
    final prefs = await SharedPreferences.getInstance();
    final isLogin = prefs.getBool('isLogin') ?? false;
    
    if (isLogin) {
      final token = await _firebaseMessaging.getToken();
      if (token != null) {
        debugPrint('FCM Token: $token');
        await _sendTokenToServer(token);
      }
    }
  }

  /// Sinkronisasi FCM token dengan backend Laravel
  static Future<void> _sendTokenToServer(String fcmToken) async {
    try {
      // Pastikan backend SIGAP (Laravel) memiliki endpoint ini
      await ApiClient.post('/user/fcm-token', {
        'fcm_token': fcmToken,
      });
      debugPrint('FCM Token berhasil disinkronisasi dengan server');
    } catch (e) {
      debugPrint('Gagal mengirim FCM token ke server: $e');
    }
  }

  /// Dapatkan daftar notifikasi dari database Laravel
  static Future<Map<String, dynamic>> getNotifications({int page = 1, int limit = 10}) async {
    try {
      final response = await ApiClient.get('/user/notifications?page=$page&limit=$limit');
      final data = ApiClient.processResponse(response);
      
      if (data['data'] is Map && data['data'].containsKey('data')) {
        final list = data['data']['data'] as List? ?? [];
        final lastPage = data['data']['last_page'] ?? 1;
        return {
          'data': list,
          'last_page': lastPage,
        };
      } else {
        final list = data['data'] as List? ?? [];
        return {
          'data': list,
          'last_page': 1,
        };
      }
    } catch (e) {
      debugPrint('Error fetching notifications: $e');
      return {
        'data': [],
        'last_page': 1,
      };
    }
  }

  /// Tandai notifikasi sebagai telah dibaca
  static Future<void> markAsRead(int notificationId) async {
    try {
      await ApiClient.post('/user/notifications/$notificationId/read', {});
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
    }
  }
}

/// Handler untuk notifikasi saat aplikasi di background (Terminated/Background)
/// Method ini HARUS berupa top-level function (di luar class)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Disini kita bisa inisialisasi Firebase jika diperlukan
  debugPrint('Handling a background message: ${message.messageId}');
}
