import 'package:cloud_firestore/cloud_firestore.dart';

class DriverFirestoreModel {
  final String? fcmToken;
  final String language;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final Timestamp? updatedAt;

  DriverFirestoreModel({
    this.fcmToken,
    required this.language,
    this.updatedAt,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
  });

  factory DriverFirestoreModel.fromJson(Map<String, dynamic> json) {
    return DriverFirestoreModel(
      fcmToken: json['fcmToken'] as String?,
      language: json['language'] as String? ?? 'en',
      updatedAt: json['updatedAt'] as Timestamp?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fcmToken': fcmToken,
      'language': language,
      'updatedAt': updatedAt,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
    };
  }

  DriverFirestoreModel copyWith({
    String? fcmToken,
    String? language,
    Timestamp? updatedAt,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
  }) {
    return DriverFirestoreModel(
      fcmToken: fcmToken ?? this.fcmToken,
      language: language ?? this.language,
      updatedAt: updatedAt ?? this.updatedAt,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }
}
