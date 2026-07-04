import '../../../../config/error_handling/result.dart';
import '../entities/change_password/change_password_request_entity.dart';
import 'package:flower_driver/features/profile/data/models/request/edit_profile_request.dart';
import 'package:flower_driver/features/profile/domain/entities/profile/driver_data_entity.dart';
import 'package:flower_driver/features/profile/domain/entities/profile/edit_profile_entity.dart';

abstract interface class ProfileRepo {
  Future<Result<ProfileDriverEntity>> getDriverData();
  Future<Result<EditProfileEntity>> editProfile(EditProfileRequest body);
  Future<Result<ProfileDriverEntity>> updateVehicle(String id, dynamic body);

  ///? Change password
  Future<Result<ChangePasswordEntity>> changePassword({
    required String password,
    required String newPassword,
  });
}
