import 'package:injectable/injectable.dart';

import '../../../../config/error_handling/result.dart';
import '../entities/change_password/change_password_request_entity.dart';

import '../repositories/profile_repo.dart';

@injectable
class ChangePasswordUseCase {
  final ProfileRepo _repo;

  ChangePasswordUseCase(this._repo);

  Future<Result<ChangePasswordEntity>> changePassword({
    required String password,
    required String newPassword,
  }) {
    return _repo.changePassword(password: password, newPassword: newPassword);
  }
}
