import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'api_client.dart';

/// Service untuk menangani data gamifikasi & leaderboard dari Laravel API.
class GamificationService {
  GamificationService._();

  /// Mengambil data leaderboard teknisi dari Laravel API.
  static Future<List<Map<String, dynamic>>?> fetchLeaderboard() async {
    try {
      final response = await ApiClient.get('/technicians/leaderboard');
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['status'] == 'success') {
          final list = decoded['data'] as List;
          return list.cast<Map<String, dynamic>>();
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error mengambil data leaderboard: $e');
      return null;
    }
  }
}
