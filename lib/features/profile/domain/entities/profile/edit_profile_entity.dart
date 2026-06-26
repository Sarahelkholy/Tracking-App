import 'package:flower_driver/config/driver/domain/entities/driver_entity.dart';

class EditProfileEntity {
  final String? message;
  final DriverEntity? driver;

  const EditProfileEntity({this.message, this.driver});
}
