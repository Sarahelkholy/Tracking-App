import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/orders/domain/entities/order_entity.dart';
import 'package:flower_driver/features/orders/domain/repositories/orders_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetActiveOrderUseCase {
  final OrdersRepo _ordersRepo;

  GetActiveOrderUseCase(this._ordersRepo);

  Stream<OrderEntity?> call(String driverId) {
    return _ordersRepo.getActiveOrder(driverId);
  }
}
