import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/auth/data/models/responses/logout_response.dart';

abstract interface class AuthRemoteDataSource {
  Future<Result<LogoutResponse>> logout();
}
