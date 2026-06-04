// lib/services/asset_service.dart
// Service untuk Manajemen Aset (Scan, Daftar)

import 'api_client.dart';
import '../models/asset_model.dart';

class AssetService {
  /// Scan aset berdasarkan kode QR/Barcode
  static Future<AssetModel?> scanAsset(String code) async {
    try {
      final response = await ApiClient.post('/asset/scan', {
        'asset_code': code,
      });
      final data = ApiClient.processResponse(response);
      if (data['data'] != null) {
        return AssetModel.fromJson(data['data']);
      }
      return null;
    } catch (e) {
      if (e.toString().contains('404')) {
        // Aset tidak ditemukan, artinya bisa didaftarkan baru
        return null;
      }
      rethrow;
    }
  }

  /// Daftarkan aset baru
  static Future<AssetModel> registerAsset(
    Map<String, dynamic> assetData,
  ) async {
    final response = await ApiClient.post('/admin/assets', assetData);
    final data = ApiClient.processResponse(response);
    return AssetModel.fromJson(data['data']);
  }

  /// Ambil semua aset
  static Future<List<AssetModel>> getAssets() async {
    final response = await ApiClient.get('/admin/assets');
    final data = ApiClient.processResponse(response);
    final list = data['data'] as List? ?? [];
    return list.map((e) => AssetModel.fromJson(e)).toList();
  }

  /// Ambil daftar aset milik user yang login
  static Future<List<AssetModel>> getUserAssets() async {
    final response = await ApiClient.get('/user/assets');
    final data = ApiClient.processResponse(response);
    final list = data['data'] as List? ?? [];
    return list.map((e) => AssetModel.fromJson(e)).toList();
  }

  /// Ambil daftar aset yang tersedia untuk dipinjam
  static Future<List<AssetModel>> getAvailableAssets({String? search}) async {
    final query = search != null
        ? '?search=${Uri.encodeComponent(search)}'
        : '';
    final response = await ApiClient.get('/assets/available$query');
    final data = ApiClient.processResponse(response);
    final list = data['data'] as List? ?? [];
    return list.map((e) => AssetModel.fromJson(e)).toList();
  }

  /// Ajukan pengambilan permanen / alokasi aset ke user yang login.
  /// Menggunakan endpoint POST /asset/transfer yang terpisah dari peminjaman.
  /// Proses ini langsung memutasi kepemilikan aset (takeover) melalui AssetService.takeover().
  static Future<Map<String, dynamic>> requestTransfer({
    required int assetId,
    required String reason,
  }) async {
    final response = await ApiClient.post('/asset/transfer', {
      'asset_id': assetId,
      'reason': reason,
    });
    return ApiClient.processResponse(response);
  }

  /// Ambil daftar semua ruangan
  static Future<List<Map<String, dynamic>>> getRooms() async {
    final response = await ApiClient.get('/rooms');
    final data = ApiClient.processResponse(response);
    final list = data['data'] as List? ?? [];
    return list.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  static Future<Map<String, dynamic>> updateAssetRoom(
    int assetId, {
    int? roomId,
    String? newRoomName,
  }) async {
    final Map<String, dynamic> body = {};
    if (roomId != null) body['room_id'] = roomId;
    if (newRoomName != null && newRoomName.trim().isNotEmpty) {
      body['new_room_name'] = newRoomName.trim();
    }
    final response = await ApiClient.post('/admin/assets/$assetId/room', body);
    return ApiClient.processResponse(response);
  }
}
