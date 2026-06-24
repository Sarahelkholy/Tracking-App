import '../../../../config/error_handling/result.dart';
import '../entities/order_entity.dart';
import '../entities/orders_entity.dart';

abstract interface class OrdersRepo {
  Future<Result<OrdersEntity>> getAllPendingOrders();
  Future<OrderEntity?> getParsedDoc(String path, String field);
}
