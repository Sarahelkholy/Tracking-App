import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/config/secure_cache/secure_cache/cache_keys.dart';
import 'package:flower_driver/config/secure_cache/secure_cache/secure_cache.dart';
import 'package:flower_driver/features/auth/data/data_source/remote/auth_remote_data_source.dart';
import 'package:flower_driver/features/auth/data/models/responses/logout_response.dart';
import 'package:flower_driver/features/auth/domain/entities/logout_response_entity.dart';
import 'package:flower_driver/features/auth/data/models/requests/login_request.dart';
import 'package:flower_driver/features/auth/data/models/responses/auth_response.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/auth_repo.dart';

@Injectable(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource _authRemoteDataSource;
  final SecureCache _secureCache;

  const AuthRepoImpl(this._authRemoteDataSource, this._secureCache);

  @override
  Future<Result<LogoutResponseEntity>> logout() async {
    final response = await _authRemoteDataSource.logout();

    switch (response) {
      case Success<LogoutResponse>():
        await _secureCache.removeData(key: CacheKeys.token);
        await _secureCache.removeData(key: CacheKeys.rememberMe);

        return Success<LogoutResponseEntity>(data: response.data.toEntity());
      case Failure<LogoutResponse>():
        return Failure<LogoutResponseEntity>(
          errorMessage: response.errorMessage,
        );
    }
  }

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
            await _secureCache.saveData(
              key: CacheKeys.token,
              value: response.data.token!,
            );

            await _secureCache.saveData(
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
