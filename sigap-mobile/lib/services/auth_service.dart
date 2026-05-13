import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_client.dart';

class AuthService {
  /// Verifikasi Login ke Laravel.
  static Future<dynamic> verifyLogin(
    String email,
    String password,
    String role,
  ) async {
    try {
      final response = await ApiClient.postPublic('/login', {
        "email": email,
        "password": password,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          // Data user dan token sekarang dibungkus dalam objek 'data' oleh Laravel
          final responseData = data['data'];
          final user = responseData['user'];
          
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('user_id', user['id'].toString());
          await prefs.setString('user_email', user['email']);
          
          // Ambil nama role pertama dari list roles yang dikirim Laravel
          String roleName = 'User';
          if (user['roles'] != null && (user['roles'] as List).isNotEmpty) {
            roleName = user['roles'][0]['name'];
          }
          await prefs.setString('user_role', roleName);
          
          await prefs.setString('user_name', user['name'] ?? '');
          await prefs.setString('user_phone', user['phone'] ?? '');
          await prefs.setString('user_nip', user['nip'] ?? '');
          
          if (responseData['token'] != null) {
            await prefs.setString('user_token', responseData['token']);
          } else {
            await prefs.setString('user_token', user['id'].toString());
          }
          return true;
        } else {
          return data['message'];
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
  static Future<dynamic> changePassword(String userId, String oldPassword, String newPassword) async {
    try {
      final response = await ApiClient.post('/change_password.php', {
        "id": userId,
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
    required String id,
    required String name,
    required String email,
    required String phone,
    required String nip,
  }) async {
    try {
      final response = await ApiClient.post('/update_profile.php', {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "nip": nip,
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
