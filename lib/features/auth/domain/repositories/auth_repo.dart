import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/auth/domain/entities/logout_response_entity.dart';

abstract interface class AuthRepo {
  Future<Result<LogoutResponseEntity>> logout();
}
