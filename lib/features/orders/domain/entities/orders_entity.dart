import 'package:equatable/equatable.dart';
import 'order_entity.dart';
import 'orders_metadata_entity.dart';

class OrdersEntity extends Equatable {
  final String message;
  final OrdersMetadataEntity metadata;
  final List<OrderEntity> orders;

  const OrdersEntity({
    required this.message,
    required this.metadata,
    required this.orders,
  });

  @override
  List<Object?> get props => [message, metadata, orders];
}
