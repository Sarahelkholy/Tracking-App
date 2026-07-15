import 'dart:async';

import 'package:flower_driver/config/base_cubit/base_cubit.dart';
import 'package:flower_driver/config/base_cubit/base_event.dart';
import 'package:flower_driver/config/base_state/base_state.dart';
import 'package:flower_driver/features/orders/domain/entities/enums/order_status_enum.dart';
import 'package:flower_driver/features/orders/domain/use_cases/complete_order_use_case.dart';
import 'package:flower_driver/features/orders/domain/use_cases/get_active_order_use_case.dart';
import 'package:flower_driver/features/orders/domain/use_cases/listen_to_active_order_use_case.dart';
import 'package:flower_driver/features/orders/domain/use_cases/listen_to_user_notification_use_case.dart';
import 'package:flower_driver/features/orders/domain/use_cases/update_driver_location_use_case.dart';
import 'package:flower_driver/features/orders/domain/use_cases/update_order_status_use_case.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

import '../../../../../config/error_handling/result.dart';
import '../../../../../config/route_manager/routes.dart';
import '../../../domain/entities/order_entity.dart';
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
    this._updateDriverLocationUseCase,
    this._completeOrderUseCase,
  ) : super(const ActiveOrderState());

  final GetActiveOrderUseCase _getActiveOrderUseCase;
  final ListenToActiveOrderUseCase _listenToActiveOrderUseCase;
  final UpdateOrderStatusUseCase _updateOrderStatusUseCase;
  final ListenToUserNotificationUseCase _listenToUserNotificationUseCase;
  final UpdateDriverLocationUseCase _updateDriverLocationUseCase;
  final CompleteOrderUseCase _completeOrderUseCase;

  StreamSubscription? _orderSubscription;
  StreamSubscription? _userSubscription;
  StreamSubscription? _locationSubscription;

  void doEvents(ActiveOrderEvents event) {
    switch (event) {
      case GetActiveOrderEvent():
        _getActiveOrder(event.driverId);
        return;
      case UpdateOrderStatusEvent():
        _updateOrderStatus(event);
        return;
      case OrderUpdatedEvent():
        _onOrderUpdated(event.order);
        return;
      case UpdateDriverLocationEvent():
        _updateDriverLocation(event);
        return;
    }
  }

  Future<void> _getActiveOrder(String driverId) async {
    emit(
      state.copyWith(
        getActiveOrderStateParam: const BaseState(isLoading: true),
      ),
    );

    final result = await _getActiveOrderUseCase.call(driverId);

    switch (result) {
      case Success():
        final order = result.data;
        emit(
          state.copyWith(
            getActiveOrderStateParam: BaseState(isSuccess: true, data: order),
            orderParam: order,
          ),
        );
        if (order != null) {
          _startListening(order.id, order.user.id);
        }
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

  void _onOrderUpdated(OrderEntity? order) {
    emit(state.copyWith(orderParam: order));
    if (order?.orderStatus == OrderStatusEnum.completed) {
      _completeOrder(order!.id);
    }
  }

  Future<void> _completeOrder(String orderId) async {
    final result = await _completeOrderUseCase.call(orderId);
    if (result is Success) {
      emitEvent(
        const NavigationEvent(
          routeName: Routes.orderSuccess,
          type: NavigationType.pushReplacementAndRemoveUntil,
        ),
      );
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
        _startLocationStreaming(order.id);
      } else {
        _stopLocationStreaming();
      }
    });

    _listenToUser(userId);
  }

  void _startLocationStreaming(String orderId) {
    if (_locationSubscription != null) return;

    _locationSubscription =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10,
          ),
        ).listen((Position position) {
          doEvents(
            UpdateDriverLocationEvent(
              orderId: orderId,
              latitude: position.latitude,
              longitude: position.longitude,
            ),
          );
        });
  }

  void _stopLocationStreaming() {
    _locationSubscription?.cancel();
    _locationSubscription = null;
  }

  void _listenToUser(String userId) {
    _userSubscription?.cancel();
    _userSubscription = _listenToUserNotificationUseCase.call(userId).listen((
      userNotification,
    ) {
      emit(state.copyWith(userNotificationParam: userNotification));
    });
  }

  Future<void> _updateDriverLocation(UpdateDriverLocationEvent event) async {
    await _updateDriverLocationUseCase.call(
      event.orderId,
      event.latitude,
      event.longitude,
    );
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
