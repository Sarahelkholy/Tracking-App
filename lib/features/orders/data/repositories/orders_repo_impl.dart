import 'package:flower_driver/config/firebase/firestore_field_name.dart';
import 'package:flower_driver/features/orders/data/data_source/remote/orders_firebase_data_source.dart';
import 'package:flower_driver/features/orders/data/mapper/active_order_firestore_mapper.dart';
import 'package:flower_driver/features/orders/data/mapper/orders_mapper.dart';
import 'package:flower_driver/features/orders/domain/entities/order_entity.dart';
import 'package:injectable/injectable.dart';

import '../../../../config/error_handling/result.dart';
import '../../domain/entities/orders_entity.dart';
import '../../domain/repositories/orders_repo.dart';
import '../data_source/remote/orders_remote_data_source.dart';
import '../models/responses/orders_response/orders_response.dart';

@Injectable(as: OrdersRepo)
class OrdersRepoImpl implements OrdersRepo {
  final OrdersRemoteDataSource _ordersRemoteDataSource;
  final OrdersFirebaseDataSource _ordersFirebaseDataSource;

  OrdersRepoImpl(this._ordersRemoteDataSource, this._ordersFirebaseDataSource);

  @override
  Future<Result<OrdersEntity>> getAllPendingOrders() async {
    final response = await _ordersRemoteDataSource.getAllPendingOrders();

    switch (response) {
      case Success<OrdersResponse>():
        return Success<OrdersEntity>(data: response.data.toEntity());
      case Failure<OrdersResponse>():
        return Failure<OrdersEntity>(errorMessage: response.errorMessage);
    }
  }

  @override
  Future<OrderEntity?> getParsedDoc(String path, String field) async {
    return null;
  }

  @override
  Future<Result<OrderEntity>> getActiveOrder(String driverId) async {
    final result = await _ordersFirebaseDataSource.getActiveOrder(driverId);

    switch (result) {
      case Success():
        return Success(data: result.data.toEntity());
      case Failure():
        return Failure(errorMessage: result.errorMessage);
    }
  }

  @override
  Stream<OrderEntity?> listenToActiveOrder(String orderId) {
    return _ordersFirebaseDataSource.listenToActiveOrder(orderId).map((
      response,
    ) {
      return response?.toEntity();
    });
  }

  @override
  Future<Result<void>> updateOrderStatus(
    OrderEntity order,
    String status, {
    bool? isActive,
  }) async {
    final updateData = <String, dynamic>{
      FireStoreFieldName.orderStatus: status,
    };
    if (isActive != null) {
      updateData[FireStoreFieldName.isActive] = isActive;
    }

    final result = await _ordersFirebaseDataSource.updateOrderStatus(
      order.id,
      updateData,
    );

    if (result is Success) {
      final fcmResult = await _ordersFirebaseDataSource.getUserFcmToken(
        order.user.id,
      );

      if (fcmResult is Success<String?> && fcmResult.data != null) {
        final fcmToken = fcmResult.data!;
        await _ordersFirebaseDataSource.sendPushNotification(
          fcmToken: fcmToken,
          title: "Order Update",
          body: "Your order #${order.orderNumber} is now $status",
        );
      }
    }

    return result;
  }
}
