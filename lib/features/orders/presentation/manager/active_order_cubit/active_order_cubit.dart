import 'dart:async';

import 'package:flower_driver/config/base_cubit/base_cubit.dart';
import 'package:flower_driver/config/base_cubit/base_event.dart';
import 'package:flower_driver/config/base_state/base_state.dart';
import 'package:flower_driver/features/orders/domain/use_cases/get_active_order_use_case.dart';
import 'package:flower_driver/features/orders/domain/use_cases/listen_to_active_order_use_case.dart';
import 'package:flower_driver/features/orders/domain/use_cases/listen_to_user_notification_use_case.dart';
import 'package:flower_driver/features/orders/domain/use_cases/update_order_status_use_case.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

import '../../../../../config/error_handling/result.dart';
import 'active_order_event.dart';
import 'active_order_state.dart';
import '../../../../../core/helpers/location_helper.dart';

@injectable
class ActiveOrderCubit extends BaseCubit<ActiveOrderState, BaseEvent> {
  ActiveOrderCubit(
    this._getActiveOrderUseCase,
    this._listenToActiveOrderUseCase,
    this._updateOrderStatusUseCase,
    this._listenToUserNotificationUseCase,
  ) : super(const ActiveOrderState());

  final GetActiveOrderUseCase _getActiveOrderUseCase;
  final ListenToActiveOrderUseCase _listenToActiveOrderUseCase;
  final UpdateOrderStatusUseCase _updateOrderStatusUseCase;
  final ListenToUserNotificationUseCase _listenToUserNotificationUseCase;

  StreamSubscription? _orderSubscription;
  StreamSubscription? _userSubscription;
  StreamSubscription<Position>? _locationSubscription;

  void doEvents(ActiveOrderEvents event) {
    switch (event) {
      case GetActiveOrderEvent():
        _getActiveOrder(event.driverId);
        return;
      case UpdateOrderStatusEvent():
        _updateOrderStatus(event);
        return;
      case OrderUpdatedEvent():
        emit(state.copyWith(orderParam: event.order));
        return;
    }
  }

  Future<void> _getActiveOrder(String driverId) async {
    emit(
      state.copyWith(
        getActiveOrderStateParam: const BaseState(isLoading: true),
      ),
    );

    try {
      final order = await _getActiveOrderUseCase.call(driverId).first;

      emit(
        state.copyWith(
          getActiveOrderStateParam: BaseState(isSuccess: true, data: order),
          orderParam: order,
        ),
      );

      if (order != null) {
        _startListening(order.id, order.user.id);
        _startTrackingLocation();
      }
    } catch (e) {
      emit(
        state.copyWith(
          getActiveOrderStateParam: BaseState(errorMessage: e.toString()),
        ),
      );
      emitEvent(DisplayErrorEvent(errorMsg: e.toString()));
    }
  }

  void _startListening(String orderId, String userId) {
    _orderSubscription?.cancel();
    _orderSubscription = _listenToActiveOrderUseCase.call(orderId).listen((
      order,
    ) {
      doEvents(OrderUpdatedEvent(order));
      if (order != null) {
        _listenToUser(order.user.id);
      }
    });

    _listenToUser(userId);
  }

  void _listenToUser(String userId) {
    _userSubscription?.cancel();
    _userSubscription = _listenToUserNotificationUseCase.call(userId).listen((
      userNotification,
    ) {
      emit(state.copyWith(userNotificationParam: userNotification));
    });
  }

  void _startTrackingLocation() {
    _locationSubscription?.cancel();
    _locationSubscription =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10,
          ),
        ).listen((position) {
          final currentOrder = state.order;
          if (currentOrder != null) {
            final updatedOrder = currentOrder.copyWith(
              currentLocation: position,
            );

            // We only want to update Firebase driverLocation continuously.
            // We can reuse _updateOrderStatusUseCase passing the same status.
            _updateOrderStatusUseCase.call(
              UpdateOrderStatusParams(
                order: updatedOrder,
                status: currentOrder.orderStatus,
              ),
            );

            // Update UI locally immediately
            emit(state.copyWith(orderParam: updatedOrder));
          }
        });
  }

  Future<void> _updateOrderStatus(UpdateOrderStatusEvent event) async {
    emit(
      state.copyWith(
        updateOrderStatusStateParam: const BaseState(isLoading: true),
      ),
    );

    final currentLocation = await LocationHelper.getCurrentLocation();
    final editedOrder = event.order.copyWith(currentLocation: currentLocation);

    final result = await _updateOrderStatusUseCase.call(
      UpdateOrderStatusParams(
        order: editedOrder,
        userNotification: state.userNotification,
        status: event.status,
        isActive: event.isActive,
      ),
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
    _userSubscription?.cancel();
    _locationSubscription?.cancel();
    return super.close();
  }
}
