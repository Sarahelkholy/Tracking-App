import 'package:flower_driver/features/auth/domain/repositories/auth_repo.dart';
import 'package:injectable/injectable.dart';

import '../../../../config/error_handling/result.dart';

@injectable
class VerifyOtpUseCase {
  final AuthRepo _repo;

  const VerifyOtpUseCase(this._repo);

  Future<Result<bool>> call({required String otp}) {
    return _repo.verifyOtp(otp: otp);
  }
}
