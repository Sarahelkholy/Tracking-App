import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'edit_profile_request.g.dart';

@JsonSerializable()
class EditProfileRequest {
  @JsonKey(name: "lastName")
  final String? lastName;
  @JsonKey(name: "firstName")
  final String? firstName;
  @JsonKey(name: "phone")
  final String? phone;
  @JsonKey(name: "photo")
  final String? photo;
  @JsonKey(name: "vehicleType")
  final String? vehicleType;
  @JsonKey(name: "vehicleNumber")
  final String? vehicleNumber;
  @JsonKey(name: "vehicleLicense")
  final String? vehicleLicense;
  @JsonKey(name: "NID")
  final String? nid;
  @JsonKey(name: "NIDImg")
  final String? nidImg;
  @JsonKey(name: "email")
  final String? email;
  @JsonKey(name: "gender")
  final String? gender;
  @JsonKey(name: "country")
  final String? country;

  EditProfileRequest({
    this.lastName,
    this.firstName,
    this.phone,
    this.photo,
    this.vehicleType,
    this.vehicleNumber,
    this.vehicleLicense,
    this.nid,
    this.nidImg,
    this.email,
    this.gender,
    this.country,
  });

  EditProfileRequest copyWith({
    String? lastName,
    String? firstName,
    String? phone,
    String? photo,
    String? vehicleType,
    String? vehicleNumber,
    String? vehicleLicense,
    String? nid,
    String? nidImg,
    String? email,
    String? gender,
    String? country,
  }) => EditProfileRequest(
    lastName: lastName ?? this.lastName,
    firstName: firstName ?? this.firstName,
    phone: phone ?? this.phone,
    photo: photo ?? this.photo,
    vehicleType: vehicleType ?? this.vehicleType,
    vehicleNumber: vehicleNumber ?? this.vehicleNumber,
    vehicleLicense: vehicleLicense ?? this.vehicleLicense,
    nid: nid ?? this.nid,
    nidImg: nidImg ?? this.nidImg,
    email: email ?? this.email,
    gender: gender ?? this.gender,
    country: country ?? this.country,
  );

  factory EditProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$EditProfileRequestFromJson(json);

  Map<String, dynamic> toJson() => _$EditProfileRequestToJson(this);
}
