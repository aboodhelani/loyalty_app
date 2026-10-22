import 'json_utils.dart';

/// In-app notification (spec §8: stamp added, card ready, reward redeemed).
class AppNotification {
  final String id;
  final String type;
  final String title;
  final String body;
  final Json payload;
  final DateTime createdAt;
  final DateTime? readAt;

  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    this.payload = const {},
    required this.createdAt,
    this.readAt,
  });

  bool get isRead => readAt != null;

  factory AppNotification.fromJson(Json json) => AppNotification(
        id: readString(json['id']),
        type: readString(json['type']),
        title: readString(json['title']),
        body: readString(json['body']),
        payload: readMap(json['payload']) ?? const {},
        createdAt: readDate(json['createdAt']) ?? DateTime.now(),
        readAt: readDate(json['readAt']),
      );
}
