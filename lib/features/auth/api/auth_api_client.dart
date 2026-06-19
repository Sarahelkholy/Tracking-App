import 'package:dio/dio.dart';
import 'package:flower_driver/features/auth/data/models/responses/auth_response.dart';
import 'package:injectable/injectable.dart';

import 'package:retrofit/retrofit.dart';
import '../../../core/values/api_end_points.dart';
import '../data/models/requests/login_request.dart';

part 'auth_api_client.g.dart';

@injectable
@RestApi()
abstract class AuthApiClient {
  @factoryMethod
  factory AuthApiClient(Dio dio) = _AuthApiClient;

  @POST(ApiEndPoints.login)
  Future<AuthResponse> signIn(@Body() LoginRequest loginRequest);
}
