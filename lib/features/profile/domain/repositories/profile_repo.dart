import '../../../../config/error_handling/result.dart';
import '../entities/change_password/change_password_request_entity.dart';

abstract interface class ProfileRepo {

  ///? Change password
  Future<Result<ChangePasswordEntity>> changePassword({
    required String password,
    required String newPassword,
  });
}