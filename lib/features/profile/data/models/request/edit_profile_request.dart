import 'package:json_annotation/json_annotation.dart';

part 'edit_profile_request.g.dart';

@JsonSerializable(includeIfNull: false)
class EditProfileRequest {
  @JsonKey(name: "lastName")
  final String? lastName;
  @JsonKey(name: "firstName")
  final String? firstName;
  @JsonKey(name: "phone")
  final String? phone;
  @JsonKey(name: "email")
  final String? email;

  EditProfileRequest({this.lastName, this.firstName, this.phone, this.email});

  EditProfileRequest copyWith({
    String? lastName,
    String? firstName,
    String? phone,
    String? email,
  }) => EditProfileRequest(
    lastName: lastName ?? this.lastName,
    firstName: firstName ?? this.firstName,
    phone: phone ?? this.phone,
    email: email ?? this.email,
  );

  factory EditProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$EditProfileRequestFromJson(json);

  Map<String, dynamic> toJson() => _$EditProfileRequestToJson(this);
}
