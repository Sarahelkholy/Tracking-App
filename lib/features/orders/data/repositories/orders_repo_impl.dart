import 'package:flower_driver/config/firebase/firestore_field_name.dart';
import 'package:flower_driver/features/orders/data/data_source/remote/orders_firebase_data_source.dart';
import 'package:flower_driver/features/orders/data/mapper/active_order_firestore_mapper.dart';
import 'package:flower_driver/features/orders/data/mapper/orders_mapper.dart';
import 'package:flower_driver/features/orders/domain/entities/enums/order_status_enum.dart';
import 'package:flower_driver/features/orders/domain/entities/order_entity.dart';
import 'package:injectable/injectable.dart';

import '../../../../config/error_handling/result.dart';
import '../../../../core/helpers/custom_logger.dart';
import '../../domain/entities/orders_entity.dart';
import '../../domain/repositories/orders_repo.dart';
import '../data_source/remote/orders_remote_data_source.dart';
import '../models/responses/active_order_firestore_response.dart';
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
  Future<Result<bool>> acceptOrder(
    OrderEntity selectedOrder,
    String driverId,
  ) async {
    final firestoreModel = ActiveOrderFirestoreResponse(
      id: selectedOrder.id,
      user: selectedOrder.user.toModel(),
      orderItems: selectedOrder.orderItems.map((e) => e.toModel()).toList(),
      totalPrice: selectedOrder.totalPrice,
      paymentType: selectedOrder.paymentType,
      isPaid: selectedOrder.isPaid,
      isDelivered: selectedOrder.isDelivered,
      state: selectedOrder.state,
      createdAt: selectedOrder.createdAt,
      updatedAt: selectedOrder.updatedAt,
      orderNumber: selectedOrder.orderNumber,
      v: selectedOrder.v,
      store: selectedOrder.store.toModel(),
      shippingAddress: selectedOrder.shippingAddress.toModel(),
      paidAt: selectedOrder.paidAt,
      orderStatus: OrderStatusEnum.accepted.name,
      driverId: driverId,
      isActive: true,
      driverLocation: selectedOrder.currentLocation != null
          ? {
              'latitude': selectedOrder.currentLocation!.latitude,
              'longitude': selectedOrder.currentLocation!.longitude,
            }
          : null,
    );

    final result = await _ordersFirebaseDataSource.saveActiveOrder(
      selectedOrder.id,
      firestoreModel.toJson(),
    );

    if (result is Success) {
      await _sendNotification(
        userId: selectedOrder.user.id,
        title: "Order Accepted",
        body:
            "Your order #${selectedOrder.orderNumber} has been accepted by the driver",
      );
    }

    switch (result) {
      case Success():
        return Success(data: true);
      case Failure():
        return Failure(errorMessage: result.errorMessage);
    }
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
      await _sendNotification(
        userId: order.user.id,
        title: "Order Update",
        body: "Your order #${order.orderNumber} is now $status",
      );
    }
    return result;
  }

  Future<void> _sendNotification({
    required String userId,
    required String title,
    required String body,
  }) async {
    final fcmResult = await _ordersFirebaseDataSource.getUserFcmToken(userId);

    CustomLogger.white("FCM Result: $fcmResult");

    if (fcmResult is Success<String?> && fcmResult.data != null) {
      await _ordersFirebaseDataSource.sendPushNotification(
        fcmToken: fcmResult.data!,
        title: title,
        body: body,
      );
    }
  }
}
