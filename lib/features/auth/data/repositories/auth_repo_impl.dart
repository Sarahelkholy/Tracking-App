import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/auth/data/data_source/remote/auth_remote_data_source.dart';
import 'package:flower_driver/features/auth/data/models/requests/login_request.dart';
import 'package:flower_driver/features/auth/data/models/responses/auth_response.dart';
import 'package:injectable/injectable.dart';

import '../../../../config/secure_cache/secure_cache/cache_keys.dart';
import '../../domain/repositories/auth_repo.dart';

@Injectable(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource _authRemoteDataSource;

  AuthRepoImpl(this._authRemoteDataSource, this.secureCache);

  final secureCache;

  @override
  Future<Result<AuthResponse>> signIn(
    LoginRequest loginRequest,
    bool rememberMe,
  ) async {
    var response = await _authRemoteDataSource.signIn(loginRequest);
    switch (response) {
      case Success<AuthResponse>():
        {
          if (response.data.token != null) {
            await secureCache.saveData(
              key: CacheKeys.token,
              value: response.data.token!,
            );

            await secureCache.saveData(
              key: CacheKeys.rememberMe,
              value: rememberMe.toString(),
            );
          }

          return Success(data: response.data);
        }
      case Failure<AuthResponse>():
        return Failure(errorMessage: response.errorMessage);
    }
  }
}
