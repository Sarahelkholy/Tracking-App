import 'dart:io';

import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/profile/data/models/request/edit_profile_request.dart';
import 'package:flower_driver/features/profile/data/models/response/driver_data_response.dart';
import 'package:flower_driver/features/profile/data/models/response/edit_profile_response.dart';
import 'package:flower_driver/features/profile/data/models/response/upload_profile_photo_response.dart';

abstract interface class ProfileRemoteDataSource {
  Future<Result<DriverDataResponse>> getDriverData();
  Future<Result<EditProfileResponse>> editProfile(EditProfileRequest body);
  Future<Result<DriverDataResponse>> updateVehicle(String id, dynamic body);
  Future<Result<UploadProfilePhotoResponse>> uploadPhoto(File photo);
}
