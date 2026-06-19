import '../../../../config/error_handling/result.dart';
import '../../data/models/requests/login_request.dart';
import '../../data/models/responses/auth_response.dart';

import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/auth/domain/entities/logout_response_entity.dart';

abstract interface class AuthRepo {
  Future<Result<AuthResponse>> signIn(
    LoginRequest loginRequest,
    bool rememberMe,
  );

  Future<Result<LogoutResponseEntity>> logout();
}
