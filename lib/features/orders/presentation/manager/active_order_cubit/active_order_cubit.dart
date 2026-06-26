import 'dart:async';

import 'package:flower_driver/config/base_cubit/base_cubit.dart';
import 'package:flower_driver/config/base_cubit/base_event.dart';
import 'package:flower_driver/config/base_state/base_state.dart';
import 'package:flower_driver/features/orders/domain/use_cases/get_active_order_use_case.dart';
import 'package:flower_driver/features/orders/domain/use_cases/listen_to_active_order_use_case.dart';
import 'package:flower_driver/features/orders/domain/use_cases/update_order_status_use_case.dart';
import 'package:injectable/injectable.dart';

import '../../../../../config/error_handling/result.dart';
import 'active_order_event.dart';
import 'active_order_state.dart';

@injectable
class ActiveOrderCubit extends BaseCubit<ActiveOrderState, BaseEvent> {
  ActiveOrderCubit(
    this._getActiveOrderUseCase,
    this._listenToActiveOrderUseCase,
    this._updateOrderStatusUseCase,
  ) : super(const ActiveOrderState());

  final GetActiveOrderUseCase _getActiveOrderUseCase;
  final ListenToActiveOrderUseCase _listenToActiveOrderUseCase;
  final UpdateOrderStatusUseCase _updateOrderStatusUseCase;

  StreamSubscription? _orderSubscription;

  void doEvents(ActiveOrderEvents event) {
    switch (event) {
      case GetActiveOrderEvent():
        _getActiveOrder();
      case UpdateOrderStatusEvent():
        _updateOrderStatus(event);
      case OrderUpdatedEvent():
        emit(state.copyWith(orderParam: event.order));
    }
  }

  Future<void> _getActiveOrder() async {
    emit(
      state.copyWith(
        getActiveOrderStateParam: const BaseState(isLoading: true),
      ),
    );

    final result = await _getActiveOrderUseCase.call("driver_demo");

    switch (result) {
      case Success():
        emit(
          state.copyWith(
            getActiveOrderStateParam: BaseState(
              isSuccess: true,
              data: result.data,
            ),
            orderParam: result.data,
          ),
        );
        _listenToOrder(result.data.id);
      case Failure():
        emit(
          state.copyWith(
            getActiveOrderStateParam: BaseState(
              errorMessage: result.errorMessage,
            ),
          ),
        );
        emitEvent(DisplayErrorEvent(errorMsg: result.errorMessage));
    }
  }

  void _listenToOrder(String orderId) {
    _orderSubscription?.cancel();
    _orderSubscription = _listenToActiveOrderUseCase.call(orderId).listen((
      order,
    ) {
      doEvents(OrderUpdatedEvent(order));
    });
  }

  Future<void> _updateOrderStatus(UpdateOrderStatusEvent event) async {
    emit(
      state.copyWith(
        updateOrderStatusStateParam: const BaseState(isLoading: true),
      ),
    );

    final result = await _updateOrderStatusUseCase.call(
      event.order,
      event.status,
      isActive: event.isActive,
    );

    switch (result) {
      case Success():
        emit(
          state.copyWith(
            updateOrderStatusStateParam: const BaseState(isSuccess: true),
          ),
        );
      case Failure():
        emit(
          state.copyWith(
            updateOrderStatusStateParam: BaseState(
              errorMessage: result.errorMessage,
            ),
          ),
        );
        emitEvent(DisplayErrorEvent(errorMsg: result.errorMessage));
    }
  }

  @override
  Future<void> close() {
    _orderSubscription?.cancel();
    return super.close();
  }
}
