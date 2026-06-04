// lib/models/loan_model.dart
// Model data untuk Peminjaman Aset

import 'package:flutter/foundation.dart';

class LoanModel {
  final int id;
  final int assetId;
  final int? userId;
  final String? namaUser;
  final String? userPhoto;
  final String namaAset;
  final String kodeAset;
  final String? kategoriAset;
  final String alasan;
  final String jenis; // 'pinjam' | 'permanen'
  final String
  status; // 'menunggu_persetujuan' | 'disetujui' | 'ditolak' | 'aktif' | 'dikembalikan' | 'jatuh_tempo'
  final String? tanggalMulai;
  final String? tanggalKembali;
  final String? tanggalDikembalikan;
  final String? catatanAdmin;
  final String createdAt;

  LoanModel({
    required this.id,
    required this.assetId,
    this.userId,
    this.namaUser,
    this.userPhoto,
    required this.namaAset,
    required this.kodeAset,
    this.kategoriAset,
    required this.alasan,
    required this.jenis,
    required this.status,
    this.tanggalMulai,
    this.tanggalKembali,
    this.tanggalDikembalikan,
    this.catatanAdmin,
    this.assetOwner,
    required this.createdAt,
  });

  factory LoanModel.fromJson(Map<String, dynamic> json) {
    try {
      return LoanModel(
        id: json['id'] != null ? int.tryParse(json['id'].toString()) ?? 0 : 0,
        assetId: json['asset_id'] != null ? int.tryParse(json['asset_id'].toString()) ?? 0 : 0,
        userId: json['user_id'] != null ? int.tryParse(json['user_id'].toString()) : null,
        namaUser: json['user']?['name'] ?? json['nama_user'] ?? json['user_name'],
        userPhoto: json['user_photo'],
        namaAset:
            json['asset']?['name'] ??
            json['nama_aset'] ??
            json['asset_name'] ??
            '',
        kodeAset:
            json['asset']?['asset_code'] ??
            json['kode_aset'] ??
            json['asset_code'] ??
            '',
        kategoriAset: json['kategori_aset'] ?? json['asset_category'],
        alasan: json['alasan'] ?? json['loan_reason'] ?? '',
        jenis: json['jenis'] ?? json['type'] ?? 'pinjam',
        status: json['status'] ?? 'pending',
        tanggalMulai: json['tanggal_mulai'] ?? json['start_date'],
        tanggalKembali: json['tanggal_kembali'] ?? json['due_date'],
        tanggalDikembalikan: json['tanggal_dikembalikan'] ?? json['returned_at'],
        catatanAdmin: json['catatan_admin'] ?? json['admin_notes'],
        createdAt: json['created_at'] ?? '',
        assetOwner: json['asset_owner'] ?? json['lender_name'],
      );
    } catch (e, stacktrace) {
      debugPrint('Error parsing LoanModel from JSON: $json');
      debugPrint('Exception: $e');
      debugPrint('Stacktrace: $stacktrace');
      rethrow;
    }
  }

  final String? assetOwner;

  bool get isPinjam  => jenis == 'pinjam';
  bool get isMutasi  => jenis == 'mutasi';
  bool get isPending => status == 'pending';
  bool get isAktif   => status == 'active';
  bool get isJatuhTempo => status == 'jatuh_tempo';

  // Status sesuai konstanta Laravel AssetLoan
  static const Map<String, Map<String, dynamic>> statusConfig = {
    'pending': {
      'label': 'Menunggu Persetujuan',
      'color': 0xFFF59E0B,
      'bgColor': 0xFFFEF3C7,
    },
    'active': {
      'label': 'Sedang Dipinjam',
      'color': 0xFF3B82F6,
      'bgColor': 0xFFEFF6FF,
    },
    'returned': {
      'label': 'Sudah Dikembalikan',
      'color': 0xFF6B7280,
      'bgColor': 0xFFF3F4F6,
    },
    'rejected': {
      'label': 'Ditolak',
      'color': 0xFFEF4444,
      'bgColor': 0xFFFEF2F2,
    },
  };

  /// Status label yang memperhitungkan jenis (pinjam vs mutasi)
  Map<String, dynamic> get statusInfo {
    if (isMutasi) {
      switch (status.toLowerCase()) {
        case 'pending':
          return {'label': 'Menunggu Persetujuan Admin', 'color': 0xFFF59E0B, 'bgColor': 0xFFFEF3C7};
        case 'active':
          return {'label': 'Dialokasikan', 'color': 0xFF7C3AED, 'bgColor': 0xFFF5F3FF};
        case 'rejected':
          return {'label': 'Pengajuan Ditolak', 'color': 0xFFEF4444, 'bgColor': 0xFFFEF2F2};
        default:
          return {'label': 'Mutasi Selesai', 'color': 0xFF6B7280, 'bgColor': 0xFFF3F4F6};
      }
    }
    return statusConfig[status.toLowerCase()] ?? statusConfig['pending']!;
  }
}
