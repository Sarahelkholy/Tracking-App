import '../../../../config/error_handling/result.dart';
import '../entities/orders_entity.dart';

abstract interface class OrdersRepo {
  Future<Result<OrdersEntity>> getAllPendingOrders();
}
