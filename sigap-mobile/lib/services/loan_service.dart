// lib/services/loan_service.dart
// Service untuk Peminjaman Aset — sesuai endpoint Laravel yang solid

import 'api_client.dart';
import '../models/loan_model.dart';

class LoanService {
  // ─── BORROWER ─────────────────────────────────────────────────────────────

  /// POST /loans — Ajukan peminjaman aset (setelah scan QR)
  static Future<Map<String, dynamic>> requestLoan({
    required int assetId,
    required String alasan,
    required String tanggalKembali,
  }) async {
    final response = await ApiClient.post('/loans', {
      'asset_id':    assetId,
      'loan_reason': alasan,
      'due_date':    tanggalKembali,
    });
    return ApiClient.processResponse(response);
  }

  /// GET /user/loans — Riwayat pinjaman milik user login
  static Future<List<LoanModel>> getMyLoans() async {
    final response = await ApiClient.get('/user/loans');
    final data = ApiClient.processResponse(response);

    // Backend wraps: { data: { loans: [...] } }
    dynamic raw = data['data'];
    if (raw is Map && raw.containsKey('loans')) {
      raw = raw['loans'];
    }
    final list = (raw as List?) ?? [];
    return list.map((e) => LoanModel.fromJson(e)).toList();
  }

  // ─── ADMIN ────────────────────────────────────────────────────────────────

  /// GET /loans?status=menunggu|disetujui|selesai&page=1&limit=10
  /// Admin: ambil semua pengajuan dengan filter status + paginasi
  static Future<Map<String, dynamic>> getAllLoans({
    String? status,
    int page = 1,
    int limit = 10,
  }) async {
    final query = StringBuffer('?page=$page&limit=$limit');
    if (status != null && status.isNotEmpty) query.write('&status=$status');

    final response = await ApiClient.get('/loans$query');
    final data = ApiClient.processResponse(response);

    // Backend returns: { data: { data: [...], last_page: N, total: N } }
    if (data['data'] is Map && data['data'].containsKey('data')) {
      final inner = data['data'] as Map<String, dynamic>;
      final list  = (inner['data'] as List?) ?? [];
      return {
        'data':      list.map((e) => LoanModel.fromJson(e)).toList(),
        'last_page': inner['last_page'] ?? 1,
        'total':     inner['total'] ?? list.length,
      };
    }

    final list = (data['data'] as List?) ?? [];
    return {
      'data':      list.map((e) => LoanModel.fromJson(e)).toList(),
      'last_page': 1,
      'total':     list.length,
    };
  }

  /// POST /loans/{id}/approve
  /// Admin: setujui (status=disetujui) atau tolak (status=ditolak) pengajuan
  static Future<void> approveLoan({
    required int loanId,
    required String status,   // 'disetujui' | 'ditolak'
    String? catatan,
  }) async {
    final response = await ApiClient.post('/loans/$loanId/approve', {
      'status':        status,
      'catatan_admin': catatan ?? '',
    });
    ApiClient.processResponse(response);
  }

  // ─── SHARED ───────────────────────────────────────────────────────────────

  /// POST /loans/{id}/return — Kembalikan aset (borrower atau admin)
  static Future<void> returnAsset({
    required int loanId,
    required String kondisiKembali,
  }) async {
    final response = await ApiClient.post('/loans/$loanId/return', {
      'kondisi_kembali': kondisiKembali,
    });
    ApiClient.processResponse(response);
  }
}
