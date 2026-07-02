import 'package:flower_driver/config/firebase/firestore_field_name.dart';
import 'package:flower_driver/features/orders/data/mapper/active_order_firestore_mapper.dart';
import 'package:flower_driver/features/orders/data/mapper/orders_mapper.dart';
import 'package:flower_driver/features/orders/domain/entities/enums/order_status_enum.dart';
import 'package:flower_driver/features/orders/domain/entities/order_entity.dart';
import 'package:injectable/injectable.dart';

import '../../../../config/error_handling/result.dart';
import '../../domain/entities/orders_entity.dart';
import '../../domain/repositories/orders_repo.dart';
import '../data_source/remote/orders_remote_data_source.dart';
import '../models/responses/active_order_firestore_response.dart';
import '../models/responses/orders_response/orders_response.dart';

@Injectable(as: OrdersRepo)
class OrdersRepoImpl implements OrdersRepo {
  final OrdersRemoteDataSource _ordersRemoteDataSource;

  OrdersRepoImpl(this._ordersRemoteDataSource);

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
  Future<OrderEntity?> getActiveOrderIfExist(String driverId) async {
    final result = await getActiveOrder(driverId);

    if (result is Success<OrderEntity>) {
      return result.data;
    }
    return null;
  }

  @override
  Future<Result<bool>> acceptOrder(
    OrderEntity selectedOrder,
    String driverId,
  ) async {
    // Convert to Firestore model for saving
    print(
      "shipping address before mapping : =====> ${selectedOrder.shippingAddress.city}",
    );

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
      currentLocation: selectedOrder.currentLocation != null
          ? {
              'latitude': selectedOrder.currentLocation!.latitude,
              'longitude': selectedOrder.currentLocation!.longitude,
            }
          : null,
    );

    print(
      "shipping address after mapping: =====> ${firestoreModel.shippingAddress?.city}",
    );


    final result = await _ordersRemoteDataSource.saveActiveOrder(
      selectedOrder.id,
      firestoreModel.toJson(),
    );

    if (result is Success) {
      // Notification logic for acceptance
      final fcmResult = await _ordersRemoteDataSource.getUserFcmToken(
        selectedOrder.user.id,
      );

      if (fcmResult is Success<String?> && fcmResult.data != null) {
        final fcmToken = fcmResult.data!;
        await _ordersRemoteDataSource.sendPushNotification(
          fcmToken: fcmToken,
          title: "Order Accepted",
          body:
              "Your order #${selectedOrder.orderNumber} has been accepted by the driver",
        );
      }
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
    final result = await _ordersRemoteDataSource.getActiveOrder(driverId);

    switch (result) {
      case Success():
        return Success(data: result.data.toEntity());
      case Failure():
        return Failure(errorMessage: result.errorMessage);
    }
  }

  @override
  Stream<OrderEntity?> listenToActiveOrder(String orderId) {
    return _ordersRemoteDataSource.listenToActiveOrder(orderId).map((response) {
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

    final result = await _ordersRemoteDataSource.updateOrderStatus(
      order.id,
      updateData,
    );

    if (result is Success) {
      // Notification logic
      final fcmResult = await _ordersRemoteDataSource.getUserFcmToken(
        order.user.id,
      );

      if (fcmResult is Success<String?> && fcmResult.data != null) {
        final fcmToken = fcmResult.data!;
        await _ordersRemoteDataSource.sendPushNotification(
          fcmToken: fcmToken,
          title: "Order Update",
          body: "Your order #${order.orderNumber} is now $status",
        );
      }
    }
    return result;
  }
}
