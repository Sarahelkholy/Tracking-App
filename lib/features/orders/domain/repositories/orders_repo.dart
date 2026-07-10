import '../../../../config/error_handling/result.dart';
import '../../domain/entities/user_notification_entity.dart';
import '../entities/order_entity.dart';
import '../entities/orders_entity.dart';
import '../use_cases/update_order_status_use_case.dart';

abstract interface class OrdersRepo {
  Future<Result<OrdersEntity>> getAllPendingOrders();

  Future<Result<bool>> acceptOrder(OrderEntity selectedOrder, String driverId);

  Stream<OrderEntity?> getActiveOrder(String driverId);

  Stream<OrderEntity?> listenToActiveOrder(String orderId);

  Stream<UserNotificationEntity?> watchUserNotificationInfo(String userId);

  Future<Result<void>> updateOrderStatus(UpdateOrderStatusParams params);

  Future<Result<void>> updateOrderLocation(
    String orderId, {
    required double latitude,
    required double longitude,
  });
}
