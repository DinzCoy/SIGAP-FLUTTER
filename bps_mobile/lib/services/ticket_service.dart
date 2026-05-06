import 'api_client.dart';

class TicketService {
  /// Kirim laporan kerusakan / tiket baru.
  static Future<Map<String, dynamic>> submitTicket({
    required String title,
    required String description,
    required String type,
    int? assetId,
  }) async {
    try {
      final Map<String, dynamic> body = {
        "title": title,
        "description": description,
        "type": type,
      };
      if (assetId != null) body["asset_id"] = assetId;

      final response = await ApiClient.post('/tickets', body);
      final data = ApiClient.processResponse(response);

      if (response.statusCode == 201 && data['status'] == 'success') {
        return {
          'success': true,
          'message': data['message'],
          'ticket_id': data['data']['ticket_id'],
        };
      } else {
        return {'success': false, 'message': data['message'] ?? 'Gagal mengirim.'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Gagal terhubung ke server.'};
    }
  }
}
