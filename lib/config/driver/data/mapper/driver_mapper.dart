import '../../domain/entities/driver_entity.dart';
import '../models/responses/driver_response.dart';

extension DriverResponseMapper on DriverResponse {
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
      createdAt: createdAt ?? DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}
