import 'package:flower_driver/features/auth/domain/repositories/auth_repo.dart';
import 'package:injectable/injectable.dart';

import '../../../../config/error_handling/result.dart';

@injectable
class EnterEmailUseCase {
  final AuthRepo _repo;

  const EnterEmailUseCase(this._repo);

  Future<Result<bool>> call({required String email}) {
    return _repo.enterEmail(email: email);
  }
}
