import '../../../../config/error_handling/result.dart';

abstract interface class AuthRepo {
  Future<Result<bool>> enterEmail({required String email});

  Future<Result<bool>> verifyOtp({required String otp});

  Future<Result<bool>> addNewPassword({
    required String email,
    required String newPassword,
  });
}
