import 'package:equatable/equatable.dart';
import 'package:flower_driver/config/base_state/base_state.dart';
import 'package:flower_driver/features/orders/domain/entities/order_entity.dart';

import '../../domain/entities/orders_entity.dart';

class HomeState extends Equatable {
  const HomeState({this.pendingOrdersState = const BaseState<OrdersEntity>()});

  final BaseState<OrdersEntity> pendingOrdersState;

  HomeState copyWith({BaseState<OrdersEntity>? pendingOrdersState}) {
    return HomeState(
      pendingOrdersState: pendingOrdersState ?? this.pendingOrdersState,
    );
  }

  @override
  List<Object?> get props => [pendingOrdersState];
}
