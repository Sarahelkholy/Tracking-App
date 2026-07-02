import 'package:flower_driver/features/orders/domain/entities/order_entity.dart';
import 'package:flower_driver/features/orders/domain/repositories/orders_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class ListenToActiveOrderUseCase {
  final OrdersRepo _ordersRepo;

  ListenToActiveOrderUseCase(this._ordersRepo);

  Stream<OrderEntity?> call(String orderId) {
    return _ordersRepo.listenToActiveOrder(orderId);
  }
}
