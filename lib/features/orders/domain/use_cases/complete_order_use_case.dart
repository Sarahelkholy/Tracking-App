import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/orders/domain/repositories/orders_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class CompleteOrderUseCase {
  final OrdersRepo _ordersRepo;

  CompleteOrderUseCase(this._ordersRepo);

  Future<Result<void>> call(String orderId) {
    return _ordersRepo.completeOrder(orderId);
  }
}
