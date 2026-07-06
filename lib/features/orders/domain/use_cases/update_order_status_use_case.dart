import 'package:equatable/equatable.dart';
import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/orders/domain/entities/enums/order_status_enum.dart';
import 'package:flower_driver/features/orders/domain/entities/order_entity.dart';
import 'package:flower_driver/features/orders/domain/entities/user_notification_entity.dart';
import 'package:flower_driver/features/orders/domain/repositories/orders_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateOrderStatusUseCase {
  final OrdersRepo _ordersRepo;

  UpdateOrderStatusUseCase(this._ordersRepo);

  Future<Result<void>> call(UpdateOrderStatusParams params) {
    return _ordersRepo.updateOrderStatus(params);
  }
}

class UpdateOrderStatusParams extends Equatable {
  final OrderEntity order;
  final UserNotificationEntity? userNotification;
  final OrderStatusEnum status;
  final bool? isActive;

  const UpdateOrderStatusParams({
    required this.order,
    this.userNotification,
    required this.status,
    this.isActive,
  });

  @override
  List<Object?> get props => [order, userNotification, status, isActive];
}
