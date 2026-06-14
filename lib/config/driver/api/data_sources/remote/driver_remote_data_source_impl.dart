import 'package:injectable/injectable.dart';
import '../../../../error_handling/execute_api.dart';
import '../../../../error_handling/result.dart';
import '../../../data/data_sources/remote/driver_remote_data_source.dart';
import '../../../data/models/responses/get_driver_data_response.dart';
import '../../driver_api_client/driver_api_client.dart';

@Injectable(as: DriverRemoteDataSource)
class DriverRemoteDataSourceImpl implements DriverRemoteDataSource {
  final DriverApiClient _apiClient;

  DriverRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Result<GetDriverDataResponse>> getDriverData() async {
    return executeApi(() async {
      var response = await _apiClient.getDriverData();
      return response;
    });
  }
}
