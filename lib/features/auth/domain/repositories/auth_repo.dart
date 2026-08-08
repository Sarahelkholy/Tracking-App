import '../../../../config/error_handling/result.dart';
import '../../../../config/error_handling/result.dart';
import '../../data/models/requests/login_request.dart';
import '../../data/models/responses/auth_response.dart';
abstract interface class AuthRepo {
  Future<Result<bool>> enterEmail({required String email});

  Future<Result<bool>> verifyOtp({required String otp});

  Future<Result<bool>> addNewPassword({
    required String email,
    required String newPassword,
  });

  Future<Result<AuthResponse>> signIn(
      LoginRequest loginRequest,
      bool rememberMe,
      );
}
