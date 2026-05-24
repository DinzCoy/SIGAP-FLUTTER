// lib/models/ticket_model.dart
// Model data untuk Tiket Layanan IT

class TicketModel {
  // Konstanta Status Tiket (sama dengan Laravel)
  static const String statusMenungguPengelola = 'Menunggu Pengecekan Pengelola';
  static const String statusKeKetuaTim = 'Diteruskan ke Ketua Tim';
  static const String statusKeTeknisi = 'Diteruskan ke Teknisi';
  static const String statusInProgress = 'In Progress';
  static const String statusMenungguBiaya = 'Menunggu Persetujuan Biaya';
  static const String statusApproved = 'Approved';
  static const String statusSelesai = 'Selesai';
  static const String statusDibatalkan = 'Dibatalkan';

  final int id;
  final String judul;
  final String deskripsi;
  final String jenis;
  final String status;
  final String priority;
  final String? reporter;
  final int? technicianId;
  final int? assetId;
  final String? namaAset;
  final String? teknisi;
  final String? tanggapan;
  final String? photoUrl;
  final String createdAt;
  final String updatedAt;

  TicketModel({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.jenis,
    required this.status,
    required this.priority,
    this.reporter,
    this.technicianId,
    this.assetId,
    this.namaAset,
    this.teknisi,
    this.tanggapan,
    this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      id: json['id'] ?? 0,
      judul: json['judul'] ?? json['title'] ?? '',
      deskripsi: json['deskripsi'] ?? json['description'] ?? '',
      jenis: json['jenis'] ?? json['type'] ?? '',
      status: json['status'] ?? 'pending',
      priority: json['priority'] ?? json['prioritas'] ?? 'Sedang',
      reporter: json['reporter'] ?? json['pelapor'],
      technicianId: json['technician_id'] != null
          ? int.tryParse(json['technician_id'].toString())
          : null,
      assetId: json['asset_id'],
      namaAset: json['nama_aset'] ?? json['asset_name'],
      teknisi: json['teknisi'] ?? json['technician'],
      tanggapan: json['tanggapan'] ?? json['response'],
      photoUrl: json['photo_url'] ?? json['foto_url'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  // Semua status dari Laravel dipetakan ke tampilan yang ramah
  static Map<String, dynamic> _getStatusInfo(String status) {
    final s = status.trim();
    // Selesai / Dibatalkan
    if (s == statusSelesai) return {'label': 'Selesai', 'color': 0xFF22C55E, 'bgColor': 0xFFF0FDF4};
    if (s == statusDibatalkan) return {'label': 'Dibatalkan', 'color': 0xFFEF4444, 'bgColor': 0xFFFEF2F2};
    // Sedang dikerjakan
    if (s == statusInProgress) return {'label': 'Dikerjakan', 'color': 0xFF3B82F6, 'bgColor': 0xFFEFF6FF};
    // Proses persetujuan
    if (s == statusApproved) return {'label': 'Disetujui', 'color': 0xFF6366F1, 'bgColor': 0xFFEEF2FF};
    if (s == statusMenungguBiaya) return {'label': 'Menunggu Biaya', 'color': 0xFFF59E0B, 'bgColor': 0xFFFEF3C7};
    if (s == statusKeKetuaTim) return {'label': 'Ke Ketua Tim', 'color': 0xFF7C3AED, 'bgColor': 0xFFF5F3FF};
    if (s == statusKeTeknisi) return {'label': 'Ke Teknisi', 'color': 0xFF0891B2, 'bgColor': 0xFFECFEFF};
    // Semua status "menunggu" lainnya → Pending
    return {'label': 'Menunggu', 'color': 0xFFF59E0B, 'bgColor': 0xFFFEF3C7};
  }

  Map<String, dynamic> get statusInfo => _getStatusInfo(status);

  /// Apakah tiket ini masih aktif?
  bool get isActive => status != statusSelesai && status != statusDibatalkan;
}
