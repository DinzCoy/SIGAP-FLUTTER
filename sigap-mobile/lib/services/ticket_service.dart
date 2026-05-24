// lib/services/ticket_service.dart
// Service untuk Tiket Layanan IT

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_client.dart';
import '../config/app_config.dart';
import '../models/ticket_model.dart';
import 'auth_service.dart';

class TicketService {
  /// Buat tiket layanan IT baru
  static Future<Map<String, dynamic>> createTicket({
    required String judul,
    required String deskripsi,
    required String jenis,
    int? assetId,
    File? foto,
  }) async {
    // Jika ada foto, gunakan multipart request
    if (foto != null) {
      final token = await AuthService.getToken();
      final url = Uri.parse('${AppConfig.baseUrl}/tickets');
      final request = http.MultipartRequest('POST', url);
      request.headers.addAll(AppConfig.getHeaders(token));
      request.fields['title'] = judul;
      request.fields['description'] = deskripsi;
      request.fields['type'] = jenis;
      if (assetId != null) request.fields['asset_id'] = assetId.toString();
      request.files.add(await http.MultipartFile.fromPath('foto', foto.path));
      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);
      return jsonDecode(response.body);
    }

    final response = await ApiClient.post('/tickets', {
      'title': judul,
      'description': deskripsi,
      'type': jenis,
      'asset_id': assetId,
    });
    return ApiClient.processResponse(response);
  }

  /// Ambil daftar tiket milik user yang login
  static Future<Map<String, dynamic>> getMyTickets({int page = 1, int limit = 10}) async {
    final response = await ApiClient.get('/tickets?page=$page&limit=$limit');
    final data = ApiClient.processResponse(response);
    
    if (data['data'] is Map && data['data'].containsKey('data')) {
      final list = data['data']['data'] as List? ?? [];
      final lastPage = data['data']['last_page'] ?? 1;
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
  static Future<Map<String, dynamic>> getAllTickets({String? status, int page = 1, int limit = 10}) async {
    final query = '?page=$page&limit=$limit${status != null ? '&status=$status' : ''}';
    final response = await ApiClient.get('/tickets$query');
    final data = ApiClient.processResponse(response);
    
    if (data['data'] is Map && data['data'].containsKey('data')) {
      final list = data['data']['data'] as List? ?? [];
      final lastPage = data['data']['last_page'] ?? 1;
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
  }) async {
    final response = await ApiClient.post('/tickets/$ticketId/status', {
      'status': status,
      'tanggapan': tanggapan,
    });
    return ApiClient.processResponse(response);
  }

  /// Ambil riwayat maintenance (servis) teknisi/ketua tim
  static Future<Map<String, dynamic>> getMaintenanceHistory({
    required int page,
    required int limit,
    String? bulan,
  }) async {
    final query = '?page=$page&limit=$limit${bulan != null ? '&bulan=$bulan' : ''}';
    final response = await ApiClient.get('/technician/maintenance$query');
    final data = ApiClient.processResponse(response);
    
    // Kembalikan map 'data' dari response JSON
    final resData = data['data'] as Map<String, dynamic>? ?? {};
    return {
      'data': resData['data'] as List? ?? [],
      'total': resData['total'] ?? 0,
      'last_page': resData['last_page'] ?? 1,
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
