// lib/models/notification_model.dart
// Model data untuk Notifikasi

class NotificationModel {
  final int id;
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
    return NotificationModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? json['judul'] ?? '',
      body: json['body'] ?? json['message'] ?? json['pesan'] ?? '',
      type: json['type'] ?? json['tipe'] ?? 'system',
      isRead: json['is_read'] == true || json['read_at'] != null || json['sudah_dibaca'] == true,
      referenceId: json['reference_id'],
      createdAt: json['created_at'] ?? '',
    );
  }
}
