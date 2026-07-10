import 'package:flower_driver/config/base_state/base_state.dart';
import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/orders/domain/entities/order_entity.dart';
import 'package:flower_driver/features/orders/domain/entities/orders_entity.dart';
import 'package:flower_driver/features/orders/domain/use_cases/accept_order_use_case.dart';
import 'package:flower_driver/features/orders/domain/use_cases/get_all_pending_orders_use_case.dart';
import 'package:flower_driver/features/orders/presentation/mangers/home_event.dart';
import 'package:flower_driver/features/orders/presentation/mangers/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/helpers/location_helper.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._getAllPendingOrdersUseCase, this._acceptOrderUseCase)
    : super(const HomeState());

  final GetAllPendingOrdersUseCase _getAllPendingOrdersUseCase;

  final AcceptOrderUseCase _acceptOrderUseCase;

  Future<void> doIntent(HomeEvent event) async {
    switch (event) {
      case GetPendingOrders():
        await _getPendingOrders();
      case SelectOrder():
        await _selectOrder(event.selectedOrder, event.driverId);
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

  Future<void> _selectOrder(OrderEntity selectedOrder, String driverId) async {
    emit(
      state.copyWith(
        selectedOrder: BaseState(
          data: selectedOrder,
          errorMessage: null,
          isSuccess: false,
          isLoading: true,
        ),
      ),
    );

    final currentLocation = await LocationHelper.getCurrentLocation();
    final editedOrder = selectedOrder.copyWith(
      currentLocation: currentLocation,
    );

    var response = await _acceptOrderUseCase(editedOrder, driverId);

    switch (response) {
      case Success<void>():
        emit(
          state.copyWith(
            selectedOrder: BaseState(
              data: editedOrder,
              errorMessage: null,
              isSuccess: true,
              isLoading: false,
            ),
          ),
        );
      case Failure<void>():
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
}
