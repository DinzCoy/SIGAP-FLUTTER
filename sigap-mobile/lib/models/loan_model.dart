// lib/models/loan_model.dart
// Model data untuk Peminjaman Aset

class LoanModel {
  final int id;
  final int assetId;
  final int? userId;
  final String? namaUser;
  final String namaAset;
  final String kodeAset;
  final String? kategoriAset;
  final String alasan;
  final String jenis; // 'pinjam' | 'permanen'
  final String status; // 'menunggu_persetujuan' | 'disetujui' | 'ditolak' | 'aktif' | 'dikembalikan' | 'jatuh_tempo'
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
    required this.createdAt,
  });

  factory LoanModel.fromJson(Map<String, dynamic> json) {
    return LoanModel(
      id: json['id'] ?? 0,
      assetId: json['asset_id'] ?? 0,
      userId: json['user_id'],
      namaUser: json['user']?['name'] ?? json['nama_user'] ?? json['user_name'],
      namaAset: json['asset']?['name'] ?? json['nama_aset'] ?? json['asset_name'] ?? '',
      kodeAset: json['asset']?['kode'] ?? json['kode_aset'] ?? json['asset_code'] ?? '',
      kategoriAset: json['kategori_aset'] ?? json['asset_category'],
      alasan: json['alasan'] ?? json['loan_reason'] ?? '',
      jenis: json['jenis'] ?? json['type'] ?? 'pinjam',
      status: json['status'] ?? 'menunggu_persetujuan',
      tanggalMulai: json['tanggal_mulai'] ?? json['start_date'],
      tanggalKembali: json['tanggal_kembali'] ?? json['due_date'],
      tanggalDikembalikan: json['tanggal_dikembalikan'] ?? json['returned_at'],
      catatanAdmin: json['catatan_admin'] ?? json['admin_notes'],
      createdAt: json['created_at'] ?? '',
    );
  }

  bool get isPinjam => jenis == 'pinjam';
  bool get isPending => status == 'menunggu_persetujuan';
  bool get isAktif => status == 'aktif' || status == 'disetujui';
  bool get isJatuhTempo => status == 'jatuh_tempo';

  static const Map<String, Map<String, dynamic>> statusConfig = {
    'menunggu_persetujuan': {
      'label': 'Menunggu Persetujuan',
      'color': 0xFFF59E0B,
      'bgColor': 0xFFFEF3C7,
    },
    'pending': { // fallback
      'label': 'Menunggu Persetujuan',
      'color': 0xFFF59E0B,
      'bgColor': 0xFFFEF3C7,
    },
    'disetujui': {
      'label': 'Disetujui',
      'color': 0xFF22C55E,
      'bgColor': 0xFFF0FDF4,
    },
    'ditolak': {'label': 'Ditolak', 'color': 0xFFEF4444, 'bgColor': 0xFFFEF2F2},
    'aktif': {
      'label': 'Sedang Dipinjam',
      'color': 0xFF3B82F6,
      'bgColor': 0xFFEFF6FF,
    },
    'dikembalikan': {
      'label': 'Sudah Dikembalikan',
      'color': 0xFF6B7280,
      'bgColor': 0xFFF3F4F6,
    },
    'jatuh_tempo': {
      'label': 'Jatuh Tempo!',
      'color': 0xFFDC2626,
      'bgColor': 0xFFFEF2F2,
    },
    'permanen': {
      'label': 'Dialokasikan Permanen',
      'color': 0xFF8B5CF6,
      'bgColor': 0xFFF5F3FF,
    },
    'selesai': {
      'label': 'Selesai',
      'color': 0xFF6B7280,
      'bgColor': 0xFFF3F4F6,
    },
  };

  Map<String, dynamic> get statusInfo =>
      statusConfig[status.toLowerCase()] ?? statusConfig['pending']!;
}
