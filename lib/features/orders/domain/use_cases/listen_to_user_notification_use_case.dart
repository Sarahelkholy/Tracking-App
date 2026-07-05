import 'package:flower_driver/features/orders/domain/entities/user_notification_entity.dart';
import 'package:flower_driver/features/orders/domain/repositories/orders_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class ListenToUserNotificationUseCase {
  final OrdersRepo _ordersRepo;

  ListenToUserNotificationUseCase(this._ordersRepo);

  Stream<UserNotificationEntity?> call(String userId) {
    return _ordersRepo.watchUserNotificationInfo(userId);
  }
}
