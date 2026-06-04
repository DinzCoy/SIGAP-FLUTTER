// lib/models/notification_model.dart
// Model data untuk Notifikasi

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String type; // 'ticket' | 'loan' | 'asset' | 'system'
  final bool isRead;
  final int? referenceId;
  final String createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.isRead,
    this.referenceId,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final Map<dynamic, dynamic> dataPayload = 
        (json['data'] is Map) ? json['data'] : json;

    int? parsedRefId;
    final refRaw = dataPayload['reference_id'] ?? dataPayload['id_peminjaman'] ?? dataPayload['id_tiket'] ?? dataPayload['id_aset'];
    if (refRaw != null) {
      parsedRefId = int.tryParse(refRaw.toString());
    }

    return NotificationModel(
      id: json['id']?.toString() ?? '',
      title: dataPayload['title']?.toString() ?? dataPayload['judul']?.toString() ?? '',
      body: dataPayload['body']?.toString() ?? dataPayload['message']?.toString() ?? dataPayload['pesan']?.toString() ?? '',
      type: dataPayload['type']?.toString() ?? dataPayload['tipe']?.toString() ?? json['type']?.toString() ?? 'system',
      isRead:
          json['is_read'] == true ||
          json['read_at'] != null ||
          json['sudah_dibaca'] == true,
      referenceId: parsedRefId,
      createdAt: json['created_at']?.toString() ?? '',
    );
  }
}
