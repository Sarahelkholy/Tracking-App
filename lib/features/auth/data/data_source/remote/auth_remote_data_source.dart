import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/auth/data/models/requests/apply_request.dart';
import 'package:flower_driver/features/auth/data/models/requests/login_request.dart';
import 'package:flower_driver/features/auth/data/models/responses/apply_response.dart';
import 'package:flower_driver/features/auth/data/models/responses/auth_response.dart';
import 'package:flower_driver/features/auth/data/models/responses/logout_response.dart';

abstract interface class AuthRemoteDataSource {
  Future<Result<ApplyResponse>> apply(ApplyRequest applyRequest);

  Future<Result<AuthResponse>> signIn(LoginRequest loginRequest);

  Future<Result<LogoutResponse>> logout();
}
