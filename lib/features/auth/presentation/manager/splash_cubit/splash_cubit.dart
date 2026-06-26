import 'package:flower_driver/config/firebase/firestore_collection.dart';
import 'package:flower_driver/features/auth/presentation/manager/splash_cubit/spalsh_events.dart';
import 'package:flower_driver/features/auth/presentation/manager/splash_cubit/splash_state.dart';
import 'package:flower_driver/features/orders/domain/repositories/orders_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../config/firebase/firestore_field_name.dart';

@LazySingleton()
class SplashCubit extends Cubit<SplashState> {
  SplashCubit(this._ordersRepo) : super(const SplashState());

  final OrdersRepo _ordersRepo;

  void doIntent(SplashEvents event) {
    switch (event) {
      case GetAcceptedOrder():
        _getAcceptedOrder();
    }
  }

  Future<void> _getAcceptedOrder() async {
    emit(const SplashState(isLoading: true));
    var acceptedOrderEntity = await _ordersRepo.getParsedDoc(
      FireStoreCollection.orderCollectionPath,
      FireStoreFieldName.orderStatus,
    );
    emit(SplashState(acceptedOrder: acceptedOrderEntity));
  }
}
