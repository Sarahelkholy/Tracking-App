import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/orders/domain/entities/order_entity.dart';
import 'package:flower_driver/features/orders/domain/repositories/orders_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class AcceptOrderUseCase {
  AcceptOrderUseCase(this._repo);

  OrdersRepo _repo;

  Future<Result<bool>> call(OrderEntity selectedOrder) async {
    return _repo.acceptOrder(selectedOrder);
  }
}
