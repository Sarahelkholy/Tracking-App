import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationFirestoreModel {
  final String id;
  final NotificationContentModel en;
  final NotificationContentModel ar;
  final Timestamp createdAt;

  NotificationFirestoreModel({
    required this.id,
    required this.en,
    required this.ar,
    required this.createdAt,
  });

  factory NotificationFirestoreModel.fromJson(Map<String, dynamic> json) =>
      NotificationFirestoreModel(
        id: json['id'] as String? ?? '',
        en: NotificationContentModel.fromJson(
          json['en'] as Map<String, dynamic>? ?? {},
        ),
        ar: NotificationContentModel.fromJson(
          json['ar'] as Map<String, dynamic>? ?? {},
        ),
        createdAt: json['createdAt'] as Timestamp,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'en': en.toJson(),
    'ar': ar.toJson(),
    'createdAt': createdAt,
  };

  NotificationFirestoreModel copyWith({
    String? id,
    NotificationContentModel? en,
    NotificationContentModel? ar,
    Timestamp? createdAt,
  }) {
    return NotificationFirestoreModel(
      id: id ?? this.id,
      en: en ?? this.en,
      ar: ar ?? this.ar,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class NotificationContentModel {
  final String title;
  final String body;

  NotificationContentModel({required this.title, required this.body});

  factory NotificationContentModel.fromJson(Map<String, dynamic> json) =>
      NotificationContentModel(
        title: json['title'] as String? ?? '',
        body: json['body'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {'title': title, 'body': body};
}
