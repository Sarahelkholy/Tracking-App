import 'package:flower_driver/features/profile/domain/entities/profile/edit_profile_entity.dart';
import 'package:flower_driver/config/driver/domain/entities/driver_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'edit_profile_response.g.dart';

@JsonSerializable()
class EditProfileResponse {
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "driver")
  final Driver? driver;

  EditProfileResponse({this.message, this.driver});

  EditProfileResponse copyWith({String? message, Driver? driver}) =>
      EditProfileResponse(
        message: message ?? this.message,
        driver: driver ?? this.driver,
      );

  factory EditProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$EditProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EditProfileResponseToJson(this);
}

@JsonSerializable()
class Driver {
  @JsonKey(name: "_id")
  final String? id;
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
  @JsonKey(name: "gender")
  final String? gender;
  @JsonKey(name: "phone")
  final String? phone;
  @JsonKey(name: "photo")
  final String? photo;
  @JsonKey(name: "role")
  final String? role;
  @JsonKey(name: "createdAt")
  final DateTime? createdAt;

  Driver({
    this.id,
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
    this.gender,
    this.phone,
    this.photo,
    this.role,
    this.createdAt,
  });

  Driver copyWith({
    String? id,
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
    String? gender,
    String? phone,
    String? photo,
    String? role,
    DateTime? createdAt,
  }) => Driver(
    id: id ?? this.id,
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
    gender: gender ?? this.gender,
    phone: phone ?? this.phone,
    photo: photo ?? this.photo,
    role: role ?? this.role,
    createdAt: createdAt ?? this.createdAt,
  );

  DriverEntity toEntity() {
    return DriverEntity(
      id: id ?? '',
      country: country ?? '',
      firstName: firstName ?? '',
      lastName: lastName ?? '',
      vehicleType: vehicleType ?? '',
      vehicleNumber: vehicleNumber ?? '',
      vehicleLicense: vehicleLicense ?? '',
      nid: nid ?? '',
      nidImg: nidImg ?? '',
      email: email ?? '',
      gender: gender ?? '',
      phone: phone ?? '',
      photo: photo ?? '',
      role: role ?? '',
      createdAt: createdAt ?? DateTime.now(),
    );
  }

  factory Driver.fromJson(Map<String, dynamic> json) => _$DriverFromJson(json);

  Map<String, dynamic> toJson() => _$DriverToJson(this);
}
