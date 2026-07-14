import 'package:flower_driver/config/data_base/data_base_service.dart';
import 'package:flower_driver/config/firebase/fcm_notification_service.dart';
import 'package:flower_driver/config/firebase/firestore_collection.dart';
import 'package:flower_driver/config/firebase/firestore_field_name.dart';
import 'package:flower_driver/features/orders/data/data_source/remote/orders_firebase_data_source.dart';
import 'package:flower_driver/features/orders/data/models/responses/active_order_firestore_response.dart';
import 'package:flower_driver/features/orders/data/models/responses/notification_firestore_model.dart';
import 'package:flower_driver/features/orders/data/models/responses/user_firestore_model.dart';
import 'package:injectable/injectable.dart';

import '../../../../../config/error_handling/execute_api.dart';
import '../../../../../config/error_handling/result.dart';

@Injectable(as: OrdersFirebaseDataSource)
class OrdersFirebaseDataSourceImpl implements OrdersFirebaseDataSource {
  final DatabaseService _databaseService;
  final FcmNotificationService _fcmNotificationService;

  OrdersFirebaseDataSourceImpl(
    this._databaseService,
    this._fcmNotificationService,
  );

  @override
  Future<Result<ActiveOrderFirestoreResponse?>> getActiveOrder(
    String driverId,
  ) {
    return executeApi(() async {
      final results = await _databaseService
          .getCollection<ActiveOrderFirestoreResponse>(
            path: FireStoreCollection.orderCollectionPath,
            queryParams: {
              FireStoreFieldName.driverId: driverId,
              FireStoreFieldName.isActive: true,
            },
            fromFirestore: ActiveOrderFirestoreResponse.fromJson,
          );
      return results.isEmpty ? null : results.first;
    });
  }

  @override
  Stream<ActiveOrderFirestoreResponse?> listenToActiveOrder(String orderId) {
    return _databaseService.watchDocument<ActiveOrderFirestoreResponse>(
      path: "${FireStoreCollection.orderCollectionPath}/$orderId",
      fromFirestore: ActiveOrderFirestoreResponse.fromJson,
    );
  }

  @override
  Future<Result<void>> updateOrderStatus(
    String orderId,
    Map<String, dynamic> data,
  ) async {
    return executeApi(
      () => _databaseService.updateData(
        path: "${FireStoreCollection.orderCollectionPath}/$orderId",
        data: data,
      ),
    );
  }

  @override
  Future<Result<void>> saveActiveOrder(
    String orderId,
    ActiveOrderFirestoreResponse data,
  ) async {
    return executeApi(
      () => _databaseService.setData<ActiveOrderFirestoreResponse>(
        path: "${FireStoreCollection.orderCollectionPath}/$orderId",
        data: data,
        toFirestore: (model) => model.toJson(),
      ),
    );
  }

  @override
  Future<Result<UserFirestoreModel?>> getUserInfo(String userId) async {
    return executeApi(() async {
      final user = await _databaseService.getDocument<UserFirestoreModel>(
        path: "${FireStoreCollection.usersCollectionPath}/$userId",
        fromFirestore: UserFirestoreModel.fromJson,
      );
      return user;
    });
  }

  @override
  Stream<UserFirestoreModel?> watchUserInfo(String userId) {
    return _databaseService.watchDocument<UserFirestoreModel>(
      path: "${FireStoreCollection.usersCollectionPath}/$userId",
      fromFirestore: UserFirestoreModel.fromJson,
    );
  }

  @override
  Future<Result<void>> saveNotification(
    String userId,
    NotificationFirestoreModel notification,
  ) async {
    return executeApi(() async {
      final path =
          "${FireStoreCollection.usersCollectionPath}/$userId/${FireStoreCollection.notificationsCollectionPath}";

      // Use addData to generate a new ID automatically
      final generatedId = await _databaseService.addData<NotificationFirestoreModel>(
        collectionPath: path,
        data: notification,
        toFirestore: (model) {
          // The requirement says: "Use the generated document id as the notification id. Save that id inside the document itself."
          // But addData needs the data to perform the add.
          // Usually we'd do this in two steps or just use the generated ID if we don't care about it being the SAME ID as the document ID inside the map.
          // If the model ALREADY has an ID from the outside, we use it.
          // If not, we might need a workaround.
          // Wait, if I use addData, Firestore returns the ID AFTER it's added.
          // If I want the ID to be INSIDE the document, I should probably generate it first.
          return model.toJson();
        },
      );

      // Since I need the ID inside the document to be the SAME as document ID:
      // I will update the document with its own ID right after adding it.
      await _databaseService.updateData(
        path: "$path/$generatedId",
        data: {'id': generatedId},
      );
    });
  }

  @override
  Future<Result<void>> sendPushNotification({
    required String fcmToken,
    required String title,
    required String body,
  }) async {
    return executeApi(() async {
      await _fcmNotificationService.sendNotification(
        fcmToken: fcmToken,
        title: title,
        body: body,
      );
    });
  }
}
