import '../../../../../config/error_handling/result.dart';
import '../../models/request/edit_profile_request.dart';
import '../../models/response/change_password_response.dart';
import '../../models/response/driver_data_response.dart';
import '../../models/response/edit_profile_response.dart';

abstract interface class ProfileRemoteDataSource {
  Future<Result<DriverDataResponse>> getDriverData();
  Future<Result<EditProfileResponse>> editProfile(EditProfileRequest body);
  Future<Result<DriverDataResponse>> updateVehicle(String id, dynamic body);

  ///? Change password
  Future<Result<ChangePasswordResponse>> changePassword({
    required String password,
    required String newPassword,
  });
}
