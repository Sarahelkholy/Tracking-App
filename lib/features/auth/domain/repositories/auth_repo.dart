import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/auth/data/models/requests/apply_request.dart';
import 'package:flower_driver/features/auth/data/models/requests/login_request.dart';
import 'package:flower_driver/features/auth/data/models/responses/apply_response.dart';
import 'package:flower_driver/features/auth/data/models/responses/auth_response.dart';
import 'package:flower_driver/features/auth/domain/entities/logout_response_entity.dart';

abstract class AuthRepo {
  /// Apply for something using [applyRequest].
  Future<Result<ApplyResponse>> apply(ApplyRequest applyRequest);

  /// Sign in with [loginRequest] and optionally remember the user.
  Future<Result<AuthResponse>> signIn(
    LoginRequest loginRequest,
    bool rememberMe,
  );

  /// Logout the current user.
  Future<Result<LogoutResponseEntity>> logout();

  Future<Result<bool>> enterEmail({required String email});

  Future<Result<bool>> verifyOtp({required String otp});

  Future<Result<bool>> addNewPassword({
    required String email,
    required String newPassword,
  });
}
