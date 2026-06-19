import '../../../../config/error_handling/result.dart';
import '../../data/models/requests/login_request.dart';
import '../../data/models/responses/auth_response.dart';

abstract interface class AuthRepo {
  Future<Result<AuthResponse>> signIn(
    LoginRequest loginRequest,
    bool rememberMe,
  );
}
