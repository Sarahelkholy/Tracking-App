import '../../../../error_handling/result.dart';
import '../../models/responses/get_driver_data_response.dart';

abstract interface class DriverRemoteDataSource {
  Future<Result<GetDriverDataResponse>> getDriverData();
}
