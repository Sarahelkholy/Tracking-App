import 'package:json_annotation/json_annotation.dart';

part 'apply_response.g.dart';

@JsonSerializable()
class ApplyResponse {
    @JsonKey(name: "message")
    final String? message;
    @JsonKey(name: "driver")
    final Driver? driver;
    @JsonKey(name: "token")
    final String? token;

    ApplyResponse({
        this.message,
        this.driver,
        this.token,
    });

    ApplyResponse copyWith({
        String? message,
        Driver? driver,
        String? token,
    }) => 
        ApplyResponse(
            message: message ?? this.message,
            driver: driver ?? this.driver,
            token: token ?? this.token,
        );

    factory ApplyResponse.fromJson(Map<String, dynamic> json) => _$ApplyResponseFromJson(json);

    Map<String, dynamic> toJson() => _$ApplyResponseToJson(this);
}

@JsonSerializable()
class Driver {
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
    @JsonKey(name: "gender")
    final String? gender;
    @JsonKey(name: "phone")
    final String? phone;
    @JsonKey(name: "photo")
    final String? photo;
    @JsonKey(name: "role")
    final String? role;
    @JsonKey(name: "_id")
    final String? id;
    @JsonKey(name: "createdAt")
    final DateTime? createdAt;

    Driver({
        this.country,
        this.firstName,
        this.lastName,
        this.vehicleType,
        this.vehicleNumber,
        this.vehicleLicense,
        this.nid,
        this.nidImg,
        this.email,
        this.gender,
        this.phone,
        this.photo,
        this.role,
        this.id,
        this.createdAt,
    });

    Driver copyWith({
        String? country,
        String? firstName,
        String? lastName,
        String? vehicleType,
        String? vehicleNumber,
        String? vehicleLicense,
        String? nid,
        String? nidImg,
        String? email,
        String? gender,
        String? phone,
        String? photo,
        String? role,
        String? id,
        DateTime? createdAt,
    }) => 
        Driver(
            country: country ?? this.country,
            firstName: firstName ?? this.firstName,
            lastName: lastName ?? this.lastName,
            vehicleType: vehicleType ?? this.vehicleType,
            vehicleNumber: vehicleNumber ?? this.vehicleNumber,
            vehicleLicense: vehicleLicense ?? this.vehicleLicense,
            nid: nid ?? this.nid,
            nidImg: nidImg ?? this.nidImg,
            email: email ?? this.email,
            gender: gender ?? this.gender,
            phone: phone ?? this.phone,
            photo: photo ?? this.photo,
            role: role ?? this.role,
            id: id ?? this.id,
            createdAt: createdAt ?? this.createdAt,
        );

    factory Driver.fromJson(Map<String, dynamic> json) => _$DriverFromJson(json);

    Map<String, dynamic> toJson() => _$DriverToJson(this);
}
