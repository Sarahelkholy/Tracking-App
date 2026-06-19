import 'package:dio/dio.dart';
import 'package:flower_driver/core/values/api_end_points.dart';
import 'package:flower_driver/features/auth/data/models/responses/logout_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:retrofit/error_logger.dart';

import 'package:retrofit/http.dart';
import 'package:retrofit/error_logger.dart';

part 'auth_api_client.g.dart';

@injectable
@RestApi()
abstract class AuthApiClient {
  @factoryMethod
  factory AuthApiClient(Dio dio) = _AuthApiClient;

  @GET(ApiEndPoints.logout)
  Future<LogoutResponse> logout();
}
