import '../../../../../config/error_handling/result.dart';
import '../../models/responses/active_order_firestore_response.dart';
import '../../models/responses/notification_firestore_model.dart';
import '../../models/responses/user_firestore_model.dart';

abstract interface class OrdersFirebaseDataSource {
  Future<Result<ActiveOrderFirestoreResponse?>> getActiveOrder(String driverId);

  Stream<ActiveOrderFirestoreResponse?> listenToActiveOrder(String orderId);

  Future<Result<void>> updateOrderStatus(
    String orderId,
    Map<String, dynamic> data,
  );

  Future<Result<void>> saveActiveOrder(
    String orderId,
    ActiveOrderFirestoreResponse data,
  );

  Future<Result<UserFirestoreModel?>> getUserInfo(String userId);

  Stream<UserFirestoreModel?> watchUserInfo(String userId);

  Future<Result<void>> saveNotification(
    String userId,
    NotificationFirestoreModel notification,
  );

  Future<Result<void>> sendPushNotification({
    required String fcmToken,
    required String title,
    required String body,
  });
}
