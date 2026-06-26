import 'package:flower_driver/features/orders/domain/entities/orders_entity.dart';

import '../../domain/entities/order_entity.dart';

sealed class HomeEvent {}

class GetPendingOrders extends HomeEvent {}

class SelectOrder extends HomeEvent {
  SelectOrder({required this.selectedOrder});

  final OrderEntity selectedOrder;
}
