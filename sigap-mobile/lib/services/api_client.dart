import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';
import 'auth_service.dart';

class ApiClient {
  /// POST tanpa auth token (untuk endpoint public seperti Login).
  static Future<http.Response> postPublic(
    String path,
    Map<String, dynamic> body,
  ) async {
    final url = Uri.parse('${AppConfig.baseUrl}$path');

    debugPrint('API POST (public): $url');
    final response = await http.post(
      url,
      headers: AppConfig.getHeaders(
        null,
      ), // Hanya kirim API Key, tanpa Bearer Token
      body: jsonEncode(body),
    );
    debugPrint('API RESPONSE [${response.statusCode}]: ${response.body}');
    return response;
  }

  /// Melakukan request POST ke API dengan API Key dan Token otomatis.
  static Future<http.Response> post(
    String path,
    Map<String, dynamic> body,
  ) async {
    final url = Uri.parse('${AppConfig.baseUrl}$path');
    final token = await AuthService.getToken();
    final prefs = await SharedPreferences.getInstance();
    final roleId = prefs.getInt('user_role_id');

    final headers = AppConfig.getHeaders(token);
    if (roleId != null) {
      headers['X-Active-Role-ID'] = roleId.toString();
    }

    debugPrint('API POST: $url');
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
    debugPrint('API RESPONSE [${response.statusCode}]: ${response.body}');
    return response;
  }

  /// Melakukan request GET ke API dengan API Key dan Token otomatis.
  static Future<http.Response> get(String path) async {
    final url = Uri.parse('${AppConfig.baseUrl}$path');
    final token = await AuthService.getToken();
    final prefs = await SharedPreferences.getInstance();
    final roleId = prefs.getInt('user_role_id');

    final headers = AppConfig.getHeaders(token);
    if (roleId != null) {
      headers['X-Active-Role-ID'] = roleId.toString();
    }

    debugPrint('API GET: $url');
    final response = await http.get(url, headers: headers);
    debugPrint('API RESPONSE [${response.statusCode}]: ${response.body}');
    return response;
  }

  /// Melakukan request POST multipart (untuk upload berkas) dengan autentikasi otomatis.
  static Future<http.Response> postMultipart(
    String path,
    Map<String, String> fields,
    Map<String, String> filePaths,
  ) async {
    final url = Uri.parse('${AppConfig.baseUrl}$path');
    final token = await AuthService.getToken();
    final prefs = await SharedPreferences.getInstance();
    final roleId = prefs.getInt('user_role_id');

    final request = http.MultipartRequest('POST', url);
    request.headers.addAll(AppConfig.getHeaders(token));
    if (roleId != null) {
      request.headers['X-Active-Role-ID'] = roleId.toString();
    }

    request.fields.addAll(fields);

    for (final entry in filePaths.entries) {
      if (entry.value.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath(entry.key, entry.value),
        );
      }
    }

    debugPrint('API POST MULTIPART: $url');
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    debugPrint('API RESPONSE [${response.statusCode}]: ${response.body}');
    return response;
  }

  /// Helper untuk memproses response JSON.
  static dynamic processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      String errorMessage = "Gagal terhubung ke server: ${response.statusCode}";
      try {
        final decoded = jsonDecode(response.body);
        if (decoded is Map && decoded['message'] != null) {
          errorMessage = decoded['message'];
        }
      } catch (e) {
        // Abaikan jika tidak bisa parsing JSON
      }
      throw Exception(errorMessage);
    }
  }
}
