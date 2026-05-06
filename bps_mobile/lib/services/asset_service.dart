import 'api_client.dart';

class AssetService {
  /// Scan QR Code aset dan dapatkan detail aset.
  static Future<Map<String, dynamic>?> scanAsset(String assetCode) async {
    try {
      final response = await ApiClient.post('/asset/scan', {"asset_code": assetCode});

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
