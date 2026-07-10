class UserFirestoreModel {
  final String? fcmToken;
  final String? language;

  UserFirestoreModel({this.fcmToken, this.language});

  factory UserFirestoreModel.fromJson(Map<String, dynamic> json) =>
      UserFirestoreModel(
        fcmToken: json['fcmToken'] as String?,
        language: json['language'] as String?,
      );

  Map<String, dynamic> toJson() => {'fcmToken': fcmToken, 'language': language};
}
