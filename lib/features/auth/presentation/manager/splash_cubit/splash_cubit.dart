import 'package:flower_driver/features/auth/presentation/manager/splash_cubit/spalsh_events.dart';
import 'package:flower_driver/features/auth/presentation/manager/splash_cubit/splash_state.dart';
import 'package:flower_driver/features/orders/domain/repositories/orders_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../config/error_handling/result.dart';
import '../../../../orders/domain/entities/order_entity.dart';

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
    try {
      final order = await _ordersRepo.getActiveOrder(driverId).first;
      emit(SplashState(acceptedOrder: order));
    } catch (e) {
      emit(const SplashState(acceptedOrder: null));
    }
  }
}
