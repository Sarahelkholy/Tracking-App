import '../../domain/entities/order_entity.dart';

sealed class HomeEvent {}

class GetPendingOrders extends HomeEvent {
  final bool isRefresh;
  GetPendingOrders({this.isRefresh = false});
}

class SelectOrder extends HomeEvent {
  SelectOrder({required this.selectedOrder, required this.driverId});

  final OrderEntity selectedOrder;
  final String driverId;
}
