// lib/models/asset_model.dart
// Model data untuk Aset — termasuk loan_status dari hasil scan QR

import 'package:flutter/material.dart';

class AssetModel {
  final int id;
  final String kode;
  final String nama;
  final String kategori;
  final String kondisi;
  String lokasi;
  final String? pemegang;
  final String? status; // status_kondisi: Berfungsi, Rusak, dll
  final String? merek;
  final String? model;
  final String? nilaiPerolehan;
  final String? tanggalPerolehan;
  final String? keterangan;

  // ─── Loan Status dari POST /asset/scan ────────────────────────────────────
  // 'available' | 'pending' | 'active'
  final String loanStatus;
  final Map<String, dynamic>? activeLoan; // {id, borrower, due_date}

  AssetModel({
    required this.id,
    required this.kode,
    required this.nama,
    required this.kategori,
    required this.kondisi,
    required this.lokasi,
    this.pemegang,
    this.status,
    this.merek,
    this.model,
    this.nilaiPerolehan,
    this.tanggalPerolehan,
    this.keterangan,
    this.loanStatus = 'available',
    this.activeLoan,
  });

  factory AssetModel.fromJson(Map<String, dynamic> json) {
    return AssetModel(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) ?? 0 : 0,
      kode: json['kode'] ?? json['asset_code'] ?? '',
      nama: json['nama'] ?? json['name'] ?? '',
      kategori: json['kategori'] ?? json['category'] ?? '',
      kondisi:
          json['kondisi'] ?? json['status_kondisi'] ?? json['condition'] ?? '',
      lokasi: json['lokasi'] ?? json['room'] ?? json['location'] ?? '',
      pemegang: json['pemegang'] ?? json['holder'],
      status: json['status_kondisi'] ?? json['status'],
      merek: json['merek'] ?? json['merk'] ?? json['brand'],
      model: json['model'],
      nilaiPerolehan: json['nilai_perolehan']?.toString(),
      tanggalPerolehan: json['tanggal_perolehan'],
      keterangan: json['keterangan'] ?? json['notes'],
      loanStatus: json['loan_status'] ?? 'available',
      activeLoan: json['active_loan'] != null
          ? Map<String, dynamic>.from(json['active_loan'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'kode': kode,
    'nama': nama,
    'kategori': kategori,
    'kondisi': kondisi,
    'lokasi': lokasi,
    'pemegang': pemegang,
    'status': status,
    'merek': merek,
    'model': model,
    'nilai_perolehan': nilaiPerolehan,
    'tanggal_perolehan': tanggalPerolehan,
    'keterangan': keterangan,
  };

  /// Apakah aset ini tersedia untuk dipinjam?
  /// Kondisi valid dari Laravel: 'Baik' atau 'Berfungsi'
  bool get isAvailable {
    if (loanStatus != 'available') return false;
    final k = kondisi.toLowerCase();
    final s = status?.toLowerCase() ?? '';
    return k == 'baik' || k == 'berfungsi' || s == 'baik' || s == 'berfungsi';
  }

  /// Apakah sedang dalam proses pengajuan?
  bool get isPendingLoan => loanStatus == 'pending';

  /// Apakah sedang aktif dipinjam?
  bool get isActiveLoan => loanStatus == 'active';

  Color get statusColor {
    switch (status?.toLowerCase() ?? kondisi.toLowerCase()) {
      case 'berfungsi':
      case 'baik':
        return const Color(0xFF22C55E);
      case 'rusak':
      case 'tidak berfungsi':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6B7280);
    }
  }

  String get statusLabel {
    switch (status?.toLowerCase() ?? kondisi.toLowerCase()) {
      case 'berfungsi':
        return 'Berfungsi';
      case 'baik':
        return 'Baik';
      case 'rusak':
        return 'Rusak';
      case 'tidak berfungsi':
        return 'Tidak Berfungsi';
      default:
        return status ?? kondisi;
    }
  }

  /// Label khusus untuk status loan (ditampilkan di badge terpisah)
  Color get loanStatusColor {
    switch (loanStatus) {
      case 'available':
        return const Color(0xFF22C55E);
      case 'pending':
        return const Color(0xFFF59E0B);
      case 'active':
        return const Color(0xFF3B82F6);
      default:
        return const Color(0xFF6B7280);
    }
  }

  String get loanStatusLabel {
    switch (loanStatus) {
      case 'available':
        return 'Tersedia';
      case 'pending':
        return 'Sedang Diajukan';
      case 'active':
        return 'Sedang Dipinjam';
      default:
        return 'Tidak Diketahui';
    }
  }
}
