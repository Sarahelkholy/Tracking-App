import 'dart:io';

import 'package:flower_driver/config/error_handling/execute_api.dart';
import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/profile/api/data_source/api_profile.dart';
import 'package:flower_driver/features/profile/data/data_source/remote/profile_remote_data_source.dart';
import 'package:flower_driver/features/profile/data/models/request/edit_profile_request.dart';
import 'package:flower_driver/features/profile/data/models/response/driver_data_response.dart';
import 'package:flower_driver/features/profile/data/models/response/edit_profile_response.dart';
import 'package:flower_driver/features/profile/data/models/response/upload_profile_photo_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiProfile apiProfile;
  ProfileRemoteDataSourceImpl(this.apiProfile);

  @override
  Future<Result<DriverDataResponse>> getDriverData() {
    return executeApi(() async {
      return await apiProfile.getDriverData();
    });
  }

  @override
  Future<Result<EditProfileResponse>> editProfile(EditProfileRequest body) {
    return executeApi(() async {
      return await apiProfile.editProfile(body);
    });
  }

  @override
  Future<Result<DriverDataResponse>> updateVehicle(String id, dynamic body) {
    return executeApi(() async {
      return await apiProfile.updateVehicle(id, body);
    });
  }

  @override
  Future<Result<UploadProfilePhotoResponse>> uploadPhoto(File photo) {
    return executeApi(() async {
      return await apiProfile.uploadPhoto(photo);
    });
  }
}
