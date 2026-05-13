import 'api_client.dart';

class DashboardService {
  /// Fetch data dashboard user.
  static Future<Map<String, dynamic>?> fetchUserDashboard() async {
    try {
      final response = await ApiClient.get('/user/dashboard');

      if (response.statusCode == 200) {
        final data = ApiClient.processResponse(response);
        if (data['status'] == 'success') {
          return data['data'];
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
