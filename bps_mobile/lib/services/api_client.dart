import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import 'auth_service.dart';

class ApiClient {
  /// Melakukan request POST ke API dengan API Key dan Token otomatis.
  static Future<http.Response> post(String path, Map<String, dynamic> body) async {
    final url = Uri.parse('${AppConfig.baseUrl}$path');
    final token = await AuthService.getToken();
    
    return await http.post(
      url,
      headers: AppConfig.getHeaders(token),
      body: jsonEncode(body),
    );
  }

  /// Melakukan request GET ke API dengan API Key dan Token otomatis.
  static Future<http.Response> get(String path) async {
    final url = Uri.parse('${AppConfig.baseUrl}$path');
    final token = await AuthService.getToken();
    
    return await http.get(
      url,
      headers: AppConfig.getHeaders(token),
    );
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
