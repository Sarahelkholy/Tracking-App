import 'package:flower_driver/features/auth/data/models/requests/login_request.dart';
import 'package:flower_driver/features/auth/domain/repositories/auth_repo.dart';
import 'package:injectable/injectable.dart';

import '../../../../config/error_handling/result.dart';
import '../../data/models/responses/auth_response.dart';

@injectable
class LoginUseCase {
  LoginUseCase(this._authRepo);

  final AuthRepo _authRepo;

  Future<Result<AuthResponse>> call(
    LoginRequest loginRequest,
    bool rememberMe,
  ) async {
    var response = await _authRepo.signIn(loginRequest, rememberMe);
    switch (response) {
      case Success<AuthResponse>():
        return Success(data: response.data);
      case Failure<AuthResponse>():
        return Failure(errorMessage: response.errorMessage);
    }
  }
}
