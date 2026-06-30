import 'dart:io';

import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/profile/data/models/request/edit_profile_request.dart';
import 'package:flower_driver/features/profile/data/models/response/upload_profile_photo_response.dart';
import 'package:flower_driver/features/profile/domain/entities/profile/driver_data_entity.dart';
import 'package:flower_driver/features/profile/domain/entities/profile/edit_profile_entity.dart';

abstract interface class ProfileRepo {
  Future<Result<ProfileDriverEntity>> getDriverData();
  Future<Result<EditProfileEntity>> editProfile(EditProfileRequest body);
  Future<Result<ProfileDriverEntity>> updateVehicle(String id, dynamic body);
  Future<Result<UploadProfilePhotoResponse>> uploadPhoto(File photo);
}
