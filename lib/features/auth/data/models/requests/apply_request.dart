import 'package:json_annotation/json_annotation.dart';

part 'apply_request.g.dart';

@JsonSerializable()
class ApplyRequest {
  @JsonKey(name: "country")
  final String? country;
  @JsonKey(name: "firstName")
  final String? firstName;
  @JsonKey(name: "lastName")
  final String? lastName;
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
  @JsonKey(name: "password")
  final String? password;
  @JsonKey(name: "rePassword")
  final String? rePassword;
  @JsonKey(name: "gender")
  final String? gender;
  @JsonKey(name: "phone")
  final String? phone;

  ApplyRequest({
    this.country,
    this.firstName,
    this.lastName,
    this.vehicleType,
    this.vehicleNumber,
    this.vehicleLicense,
    this.nid,
    this.nidImg,
    this.email,
    this.password,
    this.rePassword,
    this.gender,
    this.phone,
  });

  ApplyRequest copyWith({
    String? country,
    String? firstName,
    String? lastName,
    String? vehicleType,
    String? vehicleNumber,
    String? vehicleLicense,
    String? nid,
    String? nidImg,
    String? email,
    String? password,
    String? rePassword,
    String? gender,
    String? phone,
  }) => ApplyRequest(
    country: country ?? this.country,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    vehicleType: vehicleType ?? this.vehicleType,
    vehicleNumber: vehicleNumber ?? this.vehicleNumber,
    vehicleLicense: vehicleLicense ?? this.vehicleLicense,
    nid: nid ?? this.nid,
    nidImg: nidImg ?? this.nidImg,
    email: email ?? this.email,
    password: password ?? this.password,
    rePassword: rePassword ?? this.rePassword,
    gender: gender ?? this.gender,
    phone: phone ?? this.phone,
  );

  factory ApplyRequest.fromJson(Map<String, dynamic> json) =>
      _$ApplyRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ApplyRequestToJson(this);
}
