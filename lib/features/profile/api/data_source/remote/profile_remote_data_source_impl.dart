import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/profile/data/data_source/remote/profile_remote_data_source.dart';
import 'package:flower_driver/features/profile/data/models/response/change_password_response.dart';
import 'package:injectable/injectable.dart';

import '../../../../../config/error_handling/execute_api.dart';
import '../../../data/models/request/change_password_request.dart';
import '../../../data/models/request/edit_profile_request.dart';
import '../../../data/models/response/driver_data_response.dart';
import '../../../data/models/response/edit_profile_response.dart';
import '../api_profile.dart';

@Injectable(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiProfile _apiClient;
  ProfileRemoteDataSourceImpl(this._apiClient);

  /////? Change password
  @override
  Future<Result<ChangePasswordResponse>> changePassword({
    required String password,
    required String newPassword,
  }) {
    return executeApi(() async {
      final response = await _apiClient.changePassword(
        ChangePasswordRequest(password: password, newPassword: newPassword),
      );
      return response;
    });
  }

  @override
  Future<Result<DriverDataResponse>> getDriverData() {
    return executeApi(() async {
      return await _apiClient.getDriverData();
    });
  }

  @override
  Future<Result<EditProfileResponse>> editProfile(EditProfileRequest body) {
    return executeApi(() async {
      return await _apiClient.editProfile(body);
    });
  }

  @override
  Future<Result<DriverDataResponse>> updateVehicle(String id, dynamic body) {
    return executeApi(() async {
      return await _apiClient.updateVehicle(id, body);
    });
  }
}
