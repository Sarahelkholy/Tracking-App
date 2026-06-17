import 'package:dio/dio.dart';
import 'package:flower_driver/core/values/api_end_points.dart';
import 'package:flower_driver/features/auth/data/models/requests/apply_request.dart';
import 'package:flower_driver/features/auth/data/models/responses/apply_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';

part 'auth_api_client.g.dart';

@injectable
@RestApi()
abstract class AuthApiClient {
  @factoryMethod
  factory AuthApiClient(Dio dio) = _AuthApiClient;

  @POST(ApiEndPoints.apply)
  Future<ApplyResponse> apply(
    @Body() ApplyRequest applyRequest
  );
}
