import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/auth/domain/entities/logout_response_entity.dart';
import 'package:flower_driver/features/auth/domain/repositories/auth_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class LogoutUseCase {
  final AuthRepo _authRepo;

  LogoutUseCase(this._authRepo);

  Future<Result<LogoutResponseEntity>> call() {
    return _authRepo.logout();
  }
}
