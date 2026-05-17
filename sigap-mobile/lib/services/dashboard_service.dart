import 'api_client.dart';

class DashboardService {
  /// Fetch data dashboard user (tiket saya, aset saya).
  static Future<Map<String, dynamic>?> fetchUserDashboard() async {
    try {
      final response = await ApiClient.get('/user/dashboard');
      if (response.statusCode == 200) {
        final data = ApiClient.processResponse(response);
        if (data['status'] == 'success') return data['data'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Fetch data dashboard admin (statistik tiket & peminjaman).
  static Future<Map<String, dynamic>?> fetchAdminDashboard() async {
    try {
      final response = await ApiClient.get('/admin/dashboard');
      if (response.statusCode == 200) {
        final data = ApiClient.processResponse(response);
        if (data['status'] == 'success') return data['data'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Fetch data dashboard teknisi (tugas hari ini, riwayat perbaikan).
  static Future<Map<String, dynamic>?> fetchTechnicianDashboard() async {
    try {
      final response = await ApiClient.get('/technician/dashboard');
      if (response.statusCode == 200) {
        final data = ApiClient.processResponse(response);
        if (data['status'] == 'success') return data['data'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
