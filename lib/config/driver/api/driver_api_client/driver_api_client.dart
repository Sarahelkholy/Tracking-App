import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/values/api_end_points.dart';
import '../../data/models/responses/get_driver_data_response.dart';

part 'driver_api_client.g.dart';

@injectable
@RestApi()
abstract class DriverApiClient {
  @factoryMethod
  factory DriverApiClient(Dio dio) = _DriverApiClient;

  @GET(ApiEndPoints.getDriverData)
  Future<GetDriverDataResponse> getDriverData();
}
