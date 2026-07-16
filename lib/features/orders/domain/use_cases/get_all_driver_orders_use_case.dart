import 'package:injectable/injectable.dart';
import '../../../../config/error_handling/result.dart';
import '../entities/orders_entity.dart';
import '../repositories/orders_repo.dart';

@injectable
class GetAllDriverOrdersUseCase {
  final OrdersRepo _repo;

  GetAllDriverOrdersUseCase(this._repo);

  Future<Result<OrdersEntity>> call(int page, int limit) {
    return _repo.getAllDriverOrders(page, limit);
  }
}
