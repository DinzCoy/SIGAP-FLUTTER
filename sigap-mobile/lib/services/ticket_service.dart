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
  static Future<List<TicketModel>> getMyTickets() async {
    final response = await ApiClient.get('/user/tickets');
    final data = ApiClient.processResponse(response);
    final list = data['data'] as List? ?? [];
    return list.map((e) => TicketModel.fromJson(e)).toList();
  }

  /// Ambil semua tiket (untuk Admin/Teknisi)
  static Future<List<TicketModel>> getAllTickets({String? status}) async {
    final path = status != null
        ? '/admin/tickets?status=$status'
        : '/admin/tickets';
    final response = await ApiClient.get(path);
    final data = ApiClient.processResponse(response);
    final list = data['data'] as List? ?? [];
    return list.map((e) => TicketModel.fromJson(e)).toList();
  }

  /// Update status tiket (untuk Teknisi/Admin)
  static Future<Map<String, dynamic>> updateTicketStatus({
    required int ticketId,
    required String status,
    String? tanggapan,
  }) async {
    final response = await ApiClient.post('/admin/tickets/$ticketId/status', {
      'status': status,
      'tanggapan': tanggapan,
    });
    return ApiClient.processResponse(response);
  }
}
