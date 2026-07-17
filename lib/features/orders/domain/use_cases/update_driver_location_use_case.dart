import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/orders/domain/repositories/orders_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateDriverLocationUseCase {
  final OrdersRepo _ordersRepo;

  UpdateDriverLocationUseCase(this._ordersRepo);

  Future<Result<void>> call(String orderId, double latitude, double longitude) {
    return _ordersRepo.updateDriverLocation(orderId, latitude, longitude);
  }
}
