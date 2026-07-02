import 'package:json_annotation/json_annotation.dart';

part 'upload_profile_photo_response.g.dart';

@JsonSerializable()
class UploadProfilePhotoResponse {
  @JsonKey(name: "message")
  final String? message;

  UploadProfilePhotoResponse({this.message});

  UploadProfilePhotoResponse copyWith({String? message}) =>
      UploadProfilePhotoResponse(message: message ?? this.message);

  factory UploadProfilePhotoResponse.fromJson(Map<String, dynamic> json) =>
      _$UploadProfilePhotoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UploadProfilePhotoResponseToJson(this);
}
