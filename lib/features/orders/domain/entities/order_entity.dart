import 'package:equatable/equatable.dart';
import 'package:flower_driver/features/orders/domain/entities/enums/order_status_enum.dart';
import 'order_item_entity.dart';
import 'order_store_entity.dart';
import 'order_user_entity.dart';
import 'shipping_address_entity.dart';

class OrderEntity extends Equatable {
  final String id;
  final OrderUserEntity user;
  final List<OrderItemEntity> orderItems;
  final num totalPrice;
  final String paymentType;
  final bool isPaid;
  final bool isDelivered;
  final String state;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String orderNumber;
  final num v;
  final OrderStoreEntity store;
  final ShippingAddressEntity shippingAddress;
  final DateTime paidAt;
  final OrderStatusEnum orderStatus;

  const OrderEntity({
    required this.id,
    required this.user,
    required this.orderItems,
    required this.totalPrice,
    required this.paymentType,
    required this.isPaid,
    required this.isDelivered,
    required this.state,
    required this.createdAt,
    required this.updatedAt,
    required this.orderNumber,
    required this.v,
    required this.store,
    required this.shippingAddress,
    required this.paidAt,
    required this.orderStatus,
  });

  @override
  List<Object?> get props => [
    id,
    user,
    orderItems,
    totalPrice,
    paymentType,
    isPaid,
    isDelivered,
    state,
    createdAt,
    updatedAt,
    orderNumber,
    v,
    store,
    shippingAddress,
    paidAt,
    orderStatus
  ];
}
