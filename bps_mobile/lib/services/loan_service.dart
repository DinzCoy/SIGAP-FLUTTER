import 'api_client.dart';

class LoanService {
  /// Ajukan peminjaman aset.
  static Future<Map<String, dynamic>> requestLoan({
    required int assetId,
    required String loanReason,
    required String dueDate,
  }) async {
    try {
      final response = await ApiClient.post('/loans', {
        "asset_id": assetId,
        "loan_reason": loanReason,
        "due_date": dueDate,
      });

      final data = ApiClient.processResponse(response);
      if (response.statusCode == 201 && data['status'] == 'success') {
        return {
          'success': true,
          'message': data['message'],
          'loan_id': data['data']['loan_id'],
        };
      } else {
        return {'success': false, 'message': data['message'] ?? 'Gagal.'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Gagal terhubung.'};
    }
  }

  /// Ambil daftar peminjaman user.
  static Future<List<Map<String, dynamic>>> fetchMyLoans() async {
    try {
      final response = await ApiClient.get('/user/loans');
      if (response.statusCode == 200) {
        final data = ApiClient.processResponse(response);
        if (data['status'] == 'success') {
          return List<Map<String, dynamic>>.from(data['data']['loans']);
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
