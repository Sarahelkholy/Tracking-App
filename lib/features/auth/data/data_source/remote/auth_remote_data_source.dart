import 'package:flower_driver/features/auth/data/models/requests/login_request.dart';

import '../../../../../config/error_handling/result.dart';
import '../../models/responses/auth_response.dart';

import '../../../../../config/error_handling/result.dart';
import '../../models/responses/enter_email_response.dart';
import '../../models/responses/new_password_response.dart';
import '../../models/responses/verify_otp_response.dart';

abstract interface class AuthRemoteDataSource {
  Future<Result<EnterEmailResponse>> enterEmail({required String email});

  Future<Result<VerifyOtpResponse>> verifyOtp({required String otp});
  Future<Result<AuthResponse>> signIn(LoginRequest loginRequest);
  Future<Result<NewPasswordResponse>> addNewPassword({
    required String email,
    required String newPassword,
  });
}
