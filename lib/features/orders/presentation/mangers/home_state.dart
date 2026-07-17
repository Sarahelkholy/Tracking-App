import 'package:equatable/equatable.dart';
import 'package:flower_driver/config/base_state/base_state.dart';
import 'package:flower_driver/features/orders/domain/entities/order_entity.dart';

import '../../domain/entities/orders_entity.dart';

class HomeState extends Equatable {
  const HomeState({
    this.pendingOrdersState = const BaseState<OrdersEntity>(),
    this.selectedOrder = const BaseState<OrderEntity>(),
    this.pendingOrdersPage = 0,
    this.totalPages = 1,
  });

  final BaseState<OrdersEntity> pendingOrdersState;
  final BaseState<OrderEntity> selectedOrder;
  final int pendingOrdersPage;
  final int totalPages;

  HomeState copyWith({
    BaseState<OrdersEntity>? pendingOrdersState,
    BaseState<OrderEntity>? selectedOrder,
    int? pendingOrdersPage,
    int? totalPages,
  }) {
    return HomeState(
      pendingOrdersState: pendingOrdersState ?? this.pendingOrdersState,
      selectedOrder: selectedOrder ?? this.selectedOrder,
      pendingOrdersPage: pendingOrdersPage ?? this.pendingOrdersPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }

  @override
  List<Object?> get props => [
    pendingOrdersState,
    selectedOrder,
    pendingOrdersPage,
    totalPages,
  ];
}
