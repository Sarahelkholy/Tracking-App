import 'package:flower_driver/config/data_base/data_base_service.dart';
import 'package:flower_driver/config/firebase/firestore_collection.dart';
import 'package:flower_driver/config/firebase/firestore_field_name.dart';
import 'package:flower_driver/core/helpers/custom_logger.dart';
import 'package:flower_driver/features/orders/data/models/responses/active_order_firestore_response.dart';
import 'package:injectable/injectable.dart';
import '../../../../../config/error_handling/execute_api.dart';
import '../../../../../config/error_handling/result.dart';
import '../../../../orders/data/data_source/remote/orders_remote_data_source.dart';
import '../../../../orders/data/models/responses/orders_response/orders_response.dart';
import '../../orders_api_client.dart';

@Injectable(as: OrdersRemoteDataSource)
class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  final OrdersApiClient _apiClient;
  final DatabaseService _databaseService;

  OrdersRemoteDataSourceImpl(this._apiClient, this._databaseService);

  @override
  Future<Result<OrdersResponse>> getAllPendingOrders() {
    return executeApi(() => _apiClient.getAllPendingOrders());
  }

  @override
  Future<Result<ActiveOrderFirestoreResponse>> getActiveOrder(
    String driverId,
  ) async {
    return executeApi(() async {
      final snapshot = await _databaseService.getCollectionWhereMultiple(
        path: FireStoreCollection.orderCollectionPath,
        queryParams: {
          FireStoreFieldName.driverId: driverId,
          FireStoreFieldName.isActive: true,
        },
        limit: 1,
      );

      if (snapshot.docs.isEmpty) {
        throw Exception("No active order found");
      }

      final data = snapshot.docs.first.data();
      return ActiveOrderFirestoreResponse.fromJson(data);
    });
  }

  @override
  Stream<ActiveOrderFirestoreResponse?> listenToActiveOrder(String orderId) {
    return _databaseService
        .listenDocument("${FireStoreCollection.orderCollectionPath}/$orderId")
        .map((data) {
          if (data == null) return null;
          return ActiveOrderFirestoreResponse.fromJson(data);
        });
  }

  @override
  Future<Result<void>> updateOrderStatus(
    String orderId,
    Map<String, dynamic> data,
  ) async {
    return executeApi(
      () => _databaseService.updateData(
        "${FireStoreCollection.orderCollectionPath}/$orderId",
        data,
      ),
    );
  }

  @override
  Future<Result<void>> saveActiveOrder(
    String orderId,
    Map<String, dynamic> data,
  ) async {
    print(
      "shipping address after mapping to json: =====> ${data[ 'shippingAddress']['city']}",
    );
    return executeApi(
      () => _databaseService.setData(
        "${FireStoreCollection.orderCollectionPath}/$orderId",
        data,
      ),
    );
  }

  @override
  Future<Result<String?>> getUserFcmToken(String userId) async {
    return executeApi(() async {
      final userDoc = await _databaseService.getDocumentData(
        "${FireStoreCollection.usersCollectionPath}/$userId",
      );
      final userData = userDoc.data();
      return userData?[FireStoreFieldName.fcmToken] as String?;
    });
  }

  @override
  Future<Result<void>> sendPushNotification({
    required String fcmToken,
    required String title,
    required String body,
  }) async {
    return executeApi(() async {
      CustomLogger.bgBlue(
        "MOCK NOTIFICATION: Sending to $fcmToken: $title - $body",
      );
    });
  }
}
