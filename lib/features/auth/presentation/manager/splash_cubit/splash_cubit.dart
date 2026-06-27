import 'package:flower_driver/features/auth/presentation/manager/splash_cubit/spalsh_events.dart';
import 'package:flower_driver/features/auth/presentation/manager/splash_cubit/splash_state.dart';
import 'package:flower_driver/features/orders/domain/repositories/orders_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class SplashCubit extends Cubit<SplashState> {
  SplashCubit(this._ordersRepo) : super(const SplashState());

  final OrdersRepo _ordersRepo;

  void doIntent(SplashEvents event) {
    switch (event) {
      case GetAcceptedOrder():
        _getAcceptedOrder(event.driverId);
    }
  }

  Future<void> _getAcceptedOrder(String driverId) async {
    emit(const SplashState(isLoading: true));
    var acceptedOrderEntity = await _ordersRepo.getActiveOrderIfExist(driverId);
    emit(SplashState(acceptedOrder: acceptedOrderEntity));
  }
}
