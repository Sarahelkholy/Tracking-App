import 'package:flower_driver/features/orders/domain/entities/order_entity.dart';

sealed class ActiveOrderEvents {}

class GetActiveOrderEvent extends ActiveOrderEvents {}

class UpdateOrderStatusEvent extends ActiveOrderEvents {
  final OrderEntity order;
  final String status;
  final bool? isActive;

  UpdateOrderStatusEvent({
    required this.order,
    required this.status,
    this.isActive,
  });
}

class OrderUpdatedEvent extends ActiveOrderEvents {
  final OrderEntity? order;

  OrderUpdatedEvent(this.order);
}
