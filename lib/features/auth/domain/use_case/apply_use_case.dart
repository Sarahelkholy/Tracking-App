import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/auth/data/models/requests/apply_request.dart';
import 'package:flower_driver/features/auth/data/models/responses/apply_response.dart';
import 'package:flower_driver/features/auth/domain/repositories/auth_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class ApplyUseCase {
  ApplyUseCase(this._authRepo);
  final AuthRepo _authRepo;
  Future<Result<ApplyResponse>> call(ApplyRequest applyRequest) {
    return _authRepo.apply(applyRequest);
  }
}