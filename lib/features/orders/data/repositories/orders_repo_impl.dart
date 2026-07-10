import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flower_driver/config/firebase/firestore_field_name.dart';
import 'package:flower_driver/core/helpers/notification_localizer.dart';
import 'package:flower_driver/core/values/api_strings.dart';
import 'package:flower_driver/features/orders/data/data_source/remote/orders_firebase_data_source.dart';
import 'package:flower_driver/features/orders/data/mapper/active_order_firestore_mapper.dart';
import 'package:flower_driver/features/orders/data/mapper/orders_mapper.dart';
import 'package:flower_driver/features/orders/data/mapper/user_notification_mapper.dart';
import 'package:flower_driver/features/orders/data/models/responses/notification_firestore_model.dart';
import 'package:flower_driver/features/orders/data/models/responses/user_firestore_model.dart';
import 'package:flower_driver/features/orders/domain/entities/enums/order_status_enum.dart';
import 'package:flower_driver/features/orders/domain/entities/order_entity.dart';
import 'package:flower_driver/features/orders/domain/entities/user_notification_entity.dart';
import 'package:flower_driver/features/orders/domain/use_cases/update_order_status_use_case.dart';
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
  final OrdersFirebaseDataSource _ordersFirebaseDataSource;
  final NotificationLocalizer _notificationLocalizer;

  OrdersRepoImpl(this._ordersRemoteDataSource,
      this._ordersFirebaseDataSource,
      this._notificationLocalizer,);

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
      currentLocation: selectedOrder.currentLocation != null
          ? {
              'latitude': selectedOrder.currentLocation!.latitude,
              'longitude': selectedOrder.currentLocation!.longitude,
            }
          : null,
    );

    final result = await _ordersFirebaseDataSource.saveActiveOrder(
      selectedOrder.id,
      firestoreModel,
    );

    if (result is Success) {
      final userResult = await _ordersFirebaseDataSource.getUserInfo(
        selectedOrder.user.id,
      );
      if (userResult is Success<UserFirestoreModel?> &&
          userResult.data != null) {
        unawaited(
          _sendLocalizedNotification(
            userId: selectedOrder.user.id,
            orderNumber: selectedOrder.orderNumber,
            userNotification: userResult.data!.toNotificationEntity(),
            event: _NotificationEvent.accepted,
            status: OrderStatusEnum.accepted,
          ),
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
        response,) {
      return response?.toEntity();
    });
  }

  @override
  Stream<UserNotificationEntity?> watchUserNotificationInfo(String userId) {
    return _ordersFirebaseDataSource.watchUserInfo(userId).map((model) {
      return model?.toNotificationEntity();
    });
  }

  @override
  Future<Result<void>> updateOrderStatus(UpdateOrderStatusParams params) async {
    final updateData = <String, dynamic>{
      FireStoreFieldName.orderStatus: params.status.name,
    };
    if (params.isActive != null) {
      updateData[FireStoreFieldName.isActive] = params.isActive;
    }

    final result = await _ordersFirebaseDataSource.updateOrderStatus(
      params.order.id,
      updateData,
    );

    if (result is Success && params.userNotification != null) {
      unawaited(
        _sendLocalizedNotification(
          userId: params.order.user.id,
          orderNumber: params.order.orderNumber,
          userNotification: params.userNotification!,
          event: _NotificationEvent.update,
          status: params.status,
        ),
      );
    }
    return result;
  }

  @override
  Future<Result<void>> updateDriverLocation(String orderId,
      double latitude,
      double longitude,) {
    return _ordersFirebaseDataSource.updateOrderStatus(orderId, {
      FireStoreFieldName.currentLocation: {
        'latitude': latitude,
        'longitude': longitude,
      },
    });
  }

  @override
  Future<Result<void>> completeOrder(String orderId) {
    return _ordersRemoteDataSource.updateOrderState(
      orderId,
      ApiStrings.completed,
    );
  }

  Future<void> _sendLocalizedNotification({
    required String userId,
    required String orderNumber,
    required UserNotificationEntity userNotification,
    required _NotificationEvent event,
    required OrderStatusEnum status,
  }) async {
    // Generate English content
    final enContent = NotificationContentModel(
      title: event == _NotificationEvent.accepted
          ? _notificationLocalizer.getOrderAcceptedTitle('en')
          : _notificationLocalizer.getOrderUpdateTitle('en'),
      body: event == _NotificationEvent.accepted
          ? _notificationLocalizer.getOrderAcceptedBody('en', orderNumber)
          : _notificationLocalizer.getOrderUpdateBody(
          'en', orderNumber, status),
    );

    // Generate Arabic content
    final arContent = NotificationContentModel(
      title: event == _NotificationEvent.accepted
          ? _notificationLocalizer.getOrderAcceptedTitle('ar')
          : _notificationLocalizer.getOrderUpdateTitle('ar'),
      body: event == _NotificationEvent.accepted
          ? _notificationLocalizer.getOrderAcceptedBody('ar', orderNumber)
          : _notificationLocalizer.getOrderUpdateBody(
          'ar', orderNumber, status),
    );

    // Send push notification in user's current language
    final pushContent = userNotification.language == 'ar'
        ? arContent
        : enContent;

    await _ordersFirebaseDataSource.sendPushNotification(
      fcmToken: userNotification.fcmToken,
      title: pushContent.title,
      body: pushContent.body,
    );

    // Save notification history with nested language objects
    final notification = NotificationFirestoreModel(
      id: '', // Generated by data source
      en: enContent,
      ar: arContent,
      createdAt: Timestamp.now(),
    );

    await _ordersFirebaseDataSource.saveNotification(userId, notification);
  }
}

enum _NotificationEvent { accepted, update }
