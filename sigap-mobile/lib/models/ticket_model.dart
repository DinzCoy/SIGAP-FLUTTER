// lib/models/ticket_model.dart
// Model data untuk Tiket Layanan IT

class TicketModel {
  final int id;
  final String judul;
  final String deskripsi;
  final String jenis;
  final String status;
  final int? assetId;
  final String? namaAset;
  final String? teknisi;
  final String? tanggapan;
  final String createdAt;
  final String updatedAt;

  TicketModel({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.jenis,
    required this.status,
    this.assetId,
    this.namaAset,
    this.teknisi,
    this.tanggapan,
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
      assetId: json['asset_id'],
      namaAset: json['nama_aset'] ?? json['asset_name'],
      teknisi: json['teknisi'] ?? json['technician'],
      tanggapan: json['tanggapan'] ?? json['response'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  static const Map<String, Map<String, dynamic>> statusConfig = {
    'pending': {
      'label': 'Menunggu',
      'color': 0xFFF59E0B,
      'bgColor': 0xFFFEF3C7,
    },
    'proses': {'label': 'Diproses', 'color': 0xFF3B82F6, 'bgColor': 0xFFEFF6FF},
    'selesai': {'label': 'Selesai', 'color': 0xFF22C55E, 'bgColor': 0xFFF0FDF4},
    'ditolak': {'label': 'Ditolak', 'color': 0xFFEF4444, 'bgColor': 0xFFFEF2F2},
  };

  Map<String, dynamic> get statusInfo =>
      statusConfig[status.toLowerCase()] ?? statusConfig['pending']!;
}
