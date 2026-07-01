import 'package:injectable/injectable.dart';
import '../../../../../config/error_handling/execute_api.dart';
import '../../../../../config/error_handling/result.dart';
import '../../../../orders/data/data_source/remote/orders_remote_data_source.dart';
import '../../../../orders/data/models/responses/orders_response/orders_response.dart';
import '../../orders_api_client.dart';

@Injectable(as: OrdersRemoteDataSource)
class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  final OrdersApiClient _apiClient;

  OrdersRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Result<OrdersResponse>> getAllPendingOrders() {
    return executeApi(() => _apiClient.getAllPendingOrders());
  }
}
