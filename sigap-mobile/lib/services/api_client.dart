import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import 'auth_service.dart';

class ApiClient {
  /// POST tanpa auth token (untuk endpoint public seperti Login).
  static Future<http.Response> postPublic(String path, Map<String, dynamic> body) async {
    final url = Uri.parse('${AppConfig.baseUrl}$path');
    
    debugPrint('API POST (public): $url');
    final response = await http.post(
      url,
      headers: AppConfig.getHeaders(null), // Hanya kirim API Key, tanpa Bearer Token
      body: jsonEncode(body),
    );
    debugPrint('API RESPONSE [${response.statusCode}]: ${response.body}');
    return response;
  }

  /// Melakukan request POST ke API dengan API Key dan Token otomatis.
  static Future<http.Response> post(String path, Map<String, dynamic> body) async {
    final url = Uri.parse('${AppConfig.baseUrl}$path');
    final token = await AuthService.getToken();
    
    debugPrint('API POST: $url');
    final response = await http.post(
      url,
      headers: AppConfig.getHeaders(token),
      body: jsonEncode(body),
    );
    debugPrint('API RESPONSE [${response.statusCode}]: ${response.body}');
    return response;
  }

  /// Melakukan request GET ke API dengan API Key dan Token otomatis.
  static Future<http.Response> get(String path) async {
    final url = Uri.parse('${AppConfig.baseUrl}$path');
    final token = await AuthService.getToken();
    
    debugPrint('API GET: $url');
    final response = await http.get(
      url,
      headers: AppConfig.getHeaders(token),
    );
    debugPrint('API RESPONSE [${response.statusCode}]: ${response.body}');
    return response;
  }

  /// Helper untuk memproses response JSON.
  static dynamic processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Gagal terhubung ke server: ${response.statusCode}");
    }
  }
}
