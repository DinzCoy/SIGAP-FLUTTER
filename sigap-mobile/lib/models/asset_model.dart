// lib/models/asset_model.dart
// Model data untuk Aset

import 'package:flutter/material.dart';

class AssetModel {
  final int id;
  final String kode;
  final String nama;
  final String kategori;
  final String kondisi;
  final String lokasi;
  final String? pemegang;
  final String? status; // tersedia, dipinjam, rusak, permanen
  final String? merek;
  final String? model;
  final String? nilaiPerolehan;
  final String? tanggalPerolehan;
  final String? keterangan;

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
  });

  factory AssetModel.fromJson(Map<String, dynamic> json) {
    return AssetModel(
      id: json['id'] ?? 0,
      kode: json['kode'] ?? json['asset_code'] ?? '',
      nama: json['nama'] ?? json['name'] ?? '',
      kategori: json['kategori'] ?? json['category'] ?? '',
      kondisi: json['kondisi'] ?? json['condition'] ?? '',
      lokasi: json['lokasi'] ?? json['location'] ?? '',
      pemegang: json['pemegang'] ?? json['holder'],
      status: json['status'],
      merek: json['merek'] ?? json['brand'],
      model: json['model'],
      nilaiPerolehan: json['nilai_perolehan']?.toString(),
      tanggalPerolehan: json['tanggal_perolehan'],
      keterangan: json['keterangan'] ?? json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
  }

  Color get statusColor {
    switch (status?.toLowerCase()) {
      case 'tersedia':
        return const Color(0xFF22C55E); // green
      case 'dipinjam':
        return const Color(0xFFF59E0B); // amber
      case 'rusak':
        return const Color(0xFFEF4444); // red
      case 'permanen':
        return const Color(0xFF8B5CF6); // purple
      default:
        return const Color(0xFF6B7280); // gray
    }
  }

  String get statusLabel {
    switch (status?.toLowerCase()) {
      case 'tersedia':
        return 'Tersedia';
      case 'dipinjam':
        return 'Sedang Dipinjam';
      case 'rusak':
        return 'Rusak';
      case 'permanen':
        return 'Dialokasikan Permanen';
      default:
        return status ?? 'Tidak Diketahui';
    }
  }
}
