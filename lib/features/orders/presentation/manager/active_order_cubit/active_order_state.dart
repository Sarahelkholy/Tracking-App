import 'package:equatable/equatable.dart';
import 'package:flower_driver/config/base_state/base_state.dart';
import 'package:flower_driver/features/orders/domain/entities/order_entity.dart';

class ActiveOrderState extends Equatable {
  final BaseState<OrderEntity> getActiveOrderState;
  final BaseState<void> updateOrderStatusState;
  final OrderEntity? order;

  const ActiveOrderState({
    this.getActiveOrderState = const BaseState(),
    this.updateOrderStatusState = const BaseState(),
    this.order,
  });

  ActiveOrderState copyWith({
    BaseState<OrderEntity>? getActiveOrderStateParam,
    BaseState<void>? updateOrderStatusStateParam,
    OrderEntity? orderParam,
  }) {
    return ActiveOrderState(
      getActiveOrderState: getActiveOrderStateParam ?? getActiveOrderState,
      updateOrderStatusState:
          updateOrderStatusStateParam ?? updateOrderStatusState,
      order: orderParam ?? order,
    );
  }

  @override
  List<Object?> get props => [
    getActiveOrderState,
    updateOrderStatusState,
    order,
  ];
}
