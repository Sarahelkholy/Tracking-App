import '../../../../../config/error_handling/result.dart';
import '../../models/responses/orders_response/orders_response.dart';

abstract interface class OrdersRemoteDataSource {
  Future<Result<OrdersResponse>> getAllPendingOrders();
}
