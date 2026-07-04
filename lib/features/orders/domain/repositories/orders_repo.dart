import '../../../../config/error_handling/result.dart';
import '../entities/order_entity.dart';
import '../entities/orders_entity.dart';

abstract interface class OrdersRepo {
  Future<Result<OrdersEntity>> getAllPendingOrders();

  Future<Result<bool>> acceptOrder(OrderEntity selectedOrder, String driverId);

  Future<Result<OrderEntity>> getActiveOrder(String driverId);

  Stream<OrderEntity?> listenToActiveOrder(String orderId);

  Future<Result<void>> updateOrderStatus(
    OrderEntity order,
    String status, {
    bool? isActive,
  });
}
