import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';
import 'api_client.dart';

class AuthService {
  /// Verifikasi Login ke Laravel.
  static Future<dynamic> verifyLogin(String email, String password) async {
    try {
      final response = await ApiClient.postPublic('/login', {
        "email": email,
        "password": password,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          final responseData = data['data'];
          final user = responseData['user'];

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('user_id', user['id'].toString());
          await prefs.setString('user_email', user['email']);
          await prefs.setString('user_name', user['name'] ?? '');
          await prefs.setString('user_phone', user['phone'] ?? '');
          await prefs.setString('user_nip', user['nip'] ?? '');
          await prefs.setString('user_photo_url', user['photo_url'] ?? '');

          if (responseData['token'] != null) {
            await prefs.setString('user_token', responseData['token']);
          } else {
            await prefs.setString('user_token', user['id'].toString());
          }

          final roles =
              (user['roles'] as List?)?.cast<Map<String, dynamic>>() ?? [];
          return {'success': true, 'roles': roles};
        } else {
          return {'success': false, 'message': data['message']};
        }
      } else {
        return "Error ${response.statusCode}: ${response.reasonPhrase}";
      }
    } catch (e) {
      return "Gagal terhubung ke server. Detail: $e";
    }
  }

  /// Reset Password.
  static Future<dynamic> resetPassword(String email, String newPassword) async {
    try {
      final response = await ApiClient.post('/reset-password', {
        "email": email,
        "newPassword": newPassword,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] == 'success' ? true : data['message'];
      } else {
        return "Error ${response.statusCode}";
      }
    } catch (e) {
      return "Gagal terhubung: $e";
    }
  }

  /// Ubah Password.
  static Future<dynamic> changePassword(
    String userId,
    String oldPassword,
    String newPassword,
  ) async {
    try {
      final response = await ApiClient.post('/user/change-password', {
        "old_password": oldPassword,
        "new_password": newPassword,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] == 'success' ? true : data['message'];
      } else {
        return "Error ${response.statusCode}";
      }
    } catch (e) {
      return "Gagal terhubung: $e";
    }
  }

  /// Update Profil.
  static Future<dynamic> updateProfile({
    required String name,
    required String email,
    String? phone,
    String? nip,
    File? fotoProfil,
    bool hapusFoto = false,
  }) async {
    try {
      final token = await getToken();
      final url = Uri.parse('${AppConfig.baseUrl}/user/update-profile');
      final request = http.MultipartRequest('POST', url);
      
      request.headers.addAll(AppConfig.getHeaders(token));
      request.fields['name'] = name;
      request.fields['email'] = email;
      if (phone != null) request.fields['phone'] = phone;
      if (nip != null) request.fields['nip'] = nip;
      if (hapusFoto) request.fields['hapus_foto'] = '1';

      if (fotoProfil != null) {
        request.files.add(
          await http.MultipartFile.fromPath('foto_profil', fotoProfil.path),
        );
      }

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] == 'success' ? data : data['message'];
      } else {
        return "Error ${response.statusCode}";
      }
    } catch (e) {
      return "Gagal terhubung: $e";
    }
  }

  /// Mendapatkan token yang tersimpan.
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_token');
  }

  /// Logout.
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
