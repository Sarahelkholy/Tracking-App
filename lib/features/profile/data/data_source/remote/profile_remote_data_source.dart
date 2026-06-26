import '../../../../../config/error_handling/result.dart';
import '../../models/response/change_password_response.dart';

abstract interface class ProfileRemoteDataSource {

  ///? Change password
  Future<Result<ChangePasswordResponse>> changePassword({
    required String password,
    required String newPassword,
  });
}