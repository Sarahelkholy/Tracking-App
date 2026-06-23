import 'package:injectable/injectable.dart';
import '../../../../config/error_handling/result.dart';
import '../entities/orders_entity.dart';
import '../repositories/orders_repo.dart';

@injectable
class GetAllPendingOrdersUseCase {
  final OrdersRepo _repo;

  GetAllPendingOrdersUseCase(this._repo);

  Future<Result<OrdersEntity>> call() {
    return _repo.getAllPendingOrders();
  }
}
