import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/orders/domain/entities/order_entity.dart';
import 'package:flower_driver/features/orders/domain/repositories/orders_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class AcceptOrderUseCase {
  AcceptOrderUseCase(this._repo);

  OrdersRepo _repo;

  Future<Result<void>> call(OrderEntity selectedOrder) async {
    await _repo.acceptOrder(selectedOrder);
    return Success(data: true);
  }
}
