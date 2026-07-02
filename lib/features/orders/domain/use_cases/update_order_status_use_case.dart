import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/orders/domain/entities/order_entity.dart';
import 'package:flower_driver/features/orders/domain/repositories/orders_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateOrderStatusUseCase {
  final OrdersRepo _ordersRepo;

  UpdateOrderStatusUseCase(this._ordersRepo);

  Future<Result<void>> call(
    OrderEntity order,
    String status, {
    bool? isActive,
  }) {
    return _ordersRepo.updateOrderStatus(order, status, isActive: isActive);
  }
}
