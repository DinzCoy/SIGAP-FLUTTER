// lib/services/ticket_service.dart
// Service untuk Tiket Layanan IT

import 'dart:io';
import 'api_client.dart';
import '../models/ticket_model.dart';

class TicketService {
  /// Buat tiket layanan IT baru
  static Future<Map<String, dynamic>> createTicket({
    required String judul,
    required String deskripsi,
    required String jenis,
    required String priority,
    int? assetId,
    File? foto,
  }) async {
    // Jika ada foto, gunakan multipart request dari ApiClient
    if (foto != null) {
      final Map<String, String> fields = {
        'title': judul,
        'description': deskripsi,
        'category': jenis,
        'priority': priority,
      };
      if (assetId != null) {
        fields['asset_id'] = assetId.toString();
      }
      final response = await ApiClient.postMultipart(
        '/tickets',
        fields,
        {'foto': foto.path},
      );
      return ApiClient.processResponse(response);
    }

    final response = await ApiClient.post('/tickets', {
      'title': judul,
      'description': deskripsi,
      'category': jenis,
      'priority': priority,
      'asset_id': assetId,
    });
    return ApiClient.processResponse(response);
  }

  /// Ambil daftar tiket milik user yang login
  static Future<Map<String, dynamic>> getMyTickets({
    int page = 1,
    int limit = 10,
  }) async {
    final response = await ApiClient.get('/tickets?page=$page&limit=$limit');
    final data = ApiClient.processResponse(response);

    if (data['data'] is Map && data['data'].containsKey('data')) {
      final list = data['data']['data'] as List? ?? [];
      final lastPage = int.tryParse(data['data']['last_page']?.toString() ?? '') ?? 1;
      return {
        'data': list.map((e) => TicketModel.fromJson(e)).toList(),
        'last_page': lastPage,
      };
    } else {
      final list = data['data'] as List? ?? [];
      return {
        'data': list.map((e) => TicketModel.fromJson(e)).toList(),
        'last_page': 1,
      };
    }
  }

  /// Ambil semua tiket (untuk Admin/Teknisi)
  static Future<Map<String, dynamic>> getAllTickets({
    String? status,
    int page = 1,
    int limit = 10,
  }) async {
    final query =
        '?page=$page&limit=$limit${status != null ? '&status=$status' : ''}';
    final response = await ApiClient.get('/admin/tickets$query');
    final data = ApiClient.processResponse(response);

    if (data['data'] is Map && data['data'].containsKey('data')) {
      final list = data['data']['data'] as List? ?? [];
      final lastPage = int.tryParse(data['data']['last_page']?.toString() ?? '') ?? 1;
      return {
        'data': list.map((e) => TicketModel.fromJson(e)).toList(),
        'last_page': lastPage,
      };
    } else {
      final list = data['data'] as List? ?? [];
      return {
        'data': list.map((e) => TicketModel.fromJson(e)).toList(),
        'last_page': 1,
      };
    }
  }

  /// Update status tiket (untuk Teknisi/Admin)
  static Future<Map<String, dynamic>> updateTicketStatus({
    required int ticketId,
    required String status,
    String? tanggapan,
    int? technicianId,
  }) async {
    final Map<String, dynamic> body = {
      'status': status,
      'tanggapan': tanggapan,
    };
    if (technicianId != null) {
      body['technician_id'] = technicianId;
    }
    final response = await ApiClient.post('/admin/tickets/$ticketId/status', body);
    return ApiClient.processResponse(response);
  }

  /// Ambil riwayat maintenance (servis) teknisi/ketua tim
  static Future<Map<String, dynamic>> getMaintenanceHistory({
    required int page,
    required int limit,
    String? bulan,
  }) async {
    final query =
        '?page=$page&limit=$limit${bulan != null ? '&bulan=$bulan' : ''}';
    final response = await ApiClient.get('/technician/maintenance$query');
    final data = ApiClient.processResponse(response);

    // Kembalikan map 'data' dari response JSON
    final resData = data['data'] as Map<String, dynamic>? ?? {};
    return {
      'data': resData['data'] as List? ?? [],
      'total': resData['total'] ?? 0,
      'last_page': int.tryParse(resData['last_page']?.toString() ?? '') ?? 1,
      'is_ketua_tim': resData['is_ketua_tim'] ?? false,
    };
  }

  /// Ambil daftar semua teknisi
  static Future<List<Map<String, dynamic>>> getTechnicians() async {
    final response = await ApiClient.get('/technicians');
    final data = ApiClient.processResponse(response);
    final list = data['data'] as List? ?? [];
    return list.cast<Map<String, dynamic>>();
  }
}
