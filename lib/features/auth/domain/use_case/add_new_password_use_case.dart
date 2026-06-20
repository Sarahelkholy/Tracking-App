import 'package:flower_driver/features/auth/domain/repositories/auth_repo.dart';
import 'package:injectable/injectable.dart';

import '../../../../config/error_handling/result.dart';

@injectable
class AddNewPasswordUseCase {
  final AuthRepo _repo;

  const AddNewPasswordUseCase(this._repo);

  Future<Result<bool>> call({
    required String email,
    required String newPassword,
  }) {
    return _repo.addNewPassword(email: email, newPassword: newPassword);
  }
}
