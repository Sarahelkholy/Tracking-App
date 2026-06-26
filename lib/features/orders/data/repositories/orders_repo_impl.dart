import 'package:flower_driver/config/firebase/firestore_field_name.dart';
import 'package:flower_driver/core/helpers/custom_logger.dart';
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
  Future<OrderEntity?> getParsedDoc(String path, String field) async {
    // This method seems unused or redundant now, but keeping it as per interface if needed
    // or it could be implemented via remote data source if truly needed.
    return null;
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
  Future<Result<void>> updateOrderStatus(OrderEntity order,
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
      final fcmResult =
      await _ordersRemoteDataSource.getUserFcmToken(order.user.id);

      if (fcmResult is Success<String?> && fcmResult.data != null) {
        CustomLogger.green(
          "Sending notification to user ${order.user.id} with token ${fcmResult
              .data}. Status: $status",
        );
      }
    }

    return result;
  }
}
