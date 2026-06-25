import 'package:flower_driver/config/base_state/base_state.dart';
import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/orders/domain/entities/orders_entity.dart';
import 'package:flower_driver/features/orders/domain/use_cases/get_all_pending_orders_use_case.dart';
import 'package:flower_driver/features/orders/presentation/mangers/home_event.dart';
import 'package:flower_driver/features/orders/presentation/mangers/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._getAllPendingOrdersUseCase) : super(const HomeState());

  final GetAllPendingOrdersUseCase _getAllPendingOrdersUseCase;

  void doIntent(HomeEvent event) {
    switch (event) {
      case GetPendingOrders():
        _getPendingOrders();
    }
  }

  Future<void> _getPendingOrders() async {
    emit(
      state.copyWith(
        pendingOrdersState: const BaseState(
          isLoading: true,
          isSuccess: false,
          data: null,
          errorMessage: null,
        ),
      ),
    );

    var response = await _getAllPendingOrdersUseCase();
    switch (response) {
      case Success<OrdersEntity>():
        emit(
          state.copyWith(
            pendingOrdersState: BaseState(
              data: response.data,
              errorMessage: null,
              isSuccess: true,
              isLoading: false,
            ),
          ),
        );
      case Failure<OrdersEntity>():
        emit(
          state.copyWith(
            pendingOrdersState: BaseState(
              data: null,
              errorMessage: response.errorMessage,
              isSuccess: false,
              isLoading: false,
            ),
          ),
        );
    }
  }
}
