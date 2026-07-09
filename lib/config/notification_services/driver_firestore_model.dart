import 'package:cloud_firestore/cloud_firestore.dart';

class DriverFirestoreModel {
  final String? fcmToken;
  final String language;
  final Timestamp? updatedAt;

  DriverFirestoreModel({this.fcmToken, required this.language, this.updatedAt});

  factory DriverFirestoreModel.fromJson(Map<String, dynamic> json) {
    return DriverFirestoreModel(
      fcmToken: json['fcmToken'] as String?,
      language: json['language'] as String? ?? 'en',
      updatedAt: json['updatedAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'fcmToken': fcmToken, 'language': language, 'updatedAt': updatedAt};
  }

  DriverFirestoreModel copyWith({
    String? fcmToken,
    String? language,
    Timestamp? updatedAt,
  }) {
    return DriverFirestoreModel(
      fcmToken: fcmToken ?? this.fcmToken,
      language: language ?? this.language,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
