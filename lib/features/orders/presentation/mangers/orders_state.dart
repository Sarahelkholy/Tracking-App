import 'package:equatable/equatable.dart';
import 'package:flower_driver/config/base_state/base_state.dart';
import '../../domain/entities/orders_entity.dart';

class OrdersState extends Equatable {
  const OrdersState({
    this.ordersState = const BaseState<OrdersEntity>(),
    this.page = 0,
    this.totalPages = 1,
  });

  final BaseState<OrdersEntity> ordersState;
  final int page;
  final int totalPages;

  OrdersState copyWith({
    BaseState<OrdersEntity>? ordersState,
    int? page,
    int? totalPages,
  }) {
    return OrdersState(
      ordersState: ordersState ?? this.ordersState,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
    );
  }

  @override
  List<Object?> get props => [ordersState, page, totalPages];
}
