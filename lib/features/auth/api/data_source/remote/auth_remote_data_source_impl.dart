import 'package:flower_driver/config/error_handling/execute_api.dart';
import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/auth/api/auth_api_client.dart';
import 'package:flower_driver/features/auth/data/models/requests/login_request.dart';
import 'package:flower_driver/features/auth/data/models/responses/auth_response.dart';
import 'package:injectable/injectable.dart';

import '../../../data/data_source/remote/auth_remote_data_source.dart';

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthApiClient _apiClient;

  const AuthRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Result<AuthResponse>> signIn(LoginRequest loginRequest) {
    return executeApi(() => _apiClient.signIn(loginRequest));
  }
}
