import '../../../../../config/error_handling/result.dart';
import '../../models/responses/active_order_firestore_response.dart';
import '../../models/responses/orders_response/orders_response.dart';

abstract interface class OrdersRemoteDataSource {
  Future<Result<OrdersResponse>> getAllPendingOrders();

  Future<Result<ActiveOrderFirestoreResponse>> getActiveOrder(String driverId);

  Stream<ActiveOrderFirestoreResponse?> listenToActiveOrder(String orderId);

  Future<Result<void>> updateOrderStatus(
    String orderId,
    Map<String, dynamic> data,
  );

  Future<Result<void>> saveActiveOrder(
    String orderId,
    Map<String, dynamic> data,
  );

  Future<Result<String?>> getUserFcmToken(String userId);

  Future<Result<void>> sendPushNotification({
    required String fcmToken,
    required String title,
    required String body,
  });
}
