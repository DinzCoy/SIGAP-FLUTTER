// lib/services/loan_service.dart
// Service untuk Peminjaman & Pengambilan Permanen Aset

import 'api_client.dart';
import '../models/loan_model.dart';

class LoanService {
  /// Ajukan peminjaman aset
  static Future<Map<String, dynamic>> requestLoan({
    required int assetId,
    required String alasan,
    required String tanggalMulai,
    required String tanggalKembali,
  }) async {
    final response = await ApiClient.post('/loans', {
      'asset_id': assetId,
      'loan_reason': alasan,
      'start_date': tanggalMulai,
      'due_date': tanggalKembali,
    });
    return ApiClient.processResponse(response);
  }

  /// Ajukan pengambilan permanen (mutasi aset)
  static Future<Map<String, dynamic>> requestPermanentTransfer({
    required int assetId,
    required String alasan,
  }) async {
    final response = await ApiClient.post('/assets/$assetId/transfer', {
      'asset_id': assetId, // Optional, since id is in URL
      'reason': alasan,
    });
    return ApiClient.processResponse(response);
  }

  /// Ambil riwayat pinjaman/transfer user
  static Future<List<LoanModel>> getMyLoans() async {
    final response = await ApiClient.get('/loans/my');
    final data = ApiClient.processResponse(response);
    final list = data['data'] as List? ?? [];
    return list.map((e) => LoanModel.fromJson(e)).toList();
  }

  /// Ambil semua pengajuan (untuk Admin)
  static Future<List<LoanModel>> getAllLoans({String? status}) async {
    final path = status != null ? '/loans?status=$status' : '/loans';
    final response = await ApiClient.get(path);
    final data = ApiClient.processResponse(response);
    final list = data['data'] as List? ?? [];
    return list.map((e) => LoanModel.fromJson(e)).toList();
  }

  /// Setujui atau Tolak pinjaman (Admin)
  static Future<Map<String, dynamic>> approveLoan({
    required int loanId,
    required String status, // 'disetujui' atau 'ditolak'
    String? catatan,
  }) async {
    final response = await ApiClient.post('/loans/$loanId/approve', {
      'status': status,
      'catatan_admin': catatan,
    });
    return ApiClient.processResponse(response);
  }

  /// Kembalikan aset (User/Admin)
  static Future<Map<String, dynamic>> returnAsset({
    required int loanId,
    required String kondisiKembali,
  }) async {
    // Bisa berupa POST atau PUT tergantung desain Laravel
    final response = await ApiClient.post('/loans/$loanId/return', {
      'kondisi_kembali': kondisiKembali,
      '_method': 'PUT', // Jika backend pakai PUT
    });
    return ApiClient.processResponse(response);
  }
}
