import '../../../../../config/error_handling/result.dart';
import '../../models/responses/orders_response/orders_response.dart';

abstract interface class OrdersRemoteDataSource {


  Future<Result<void>> updateOrderState(String orderId, String state);
  Future<Result<OrdersResponse>> getAllPendingOrders(int page, int limit);
}
