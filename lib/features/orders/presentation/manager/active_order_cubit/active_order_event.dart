import 'package:flower_driver/features/orders/domain/entities/enums/order_status_enum.dart';
import 'package:flower_driver/features/orders/domain/entities/order_entity.dart';

sealed class ActiveOrderEvents {}

class GetActiveOrderEvent extends ActiveOrderEvents {
  final String driverId;

  GetActiveOrderEvent({required this.driverId});
}

class UpdateOrderStatusEvent extends ActiveOrderEvents {
  final OrderEntity order;
  final OrderStatusEnum status;
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
