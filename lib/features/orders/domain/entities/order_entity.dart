import 'package:equatable/equatable.dart';
import 'package:flower_driver/features/orders/domain/entities/enums/order_status_enum.dart';
import 'package:geolocator/geolocator.dart';

import '../../data/models/responses/orders_response/order_data_response.dart';
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
  final Position? currentLocation;

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
    this.currentLocation,
  });

  OrderEntity copyWith({
    String? id,
    OrderUserEntity? user,
    List<OrderItemEntity>? orderItems,
    num? totalPrice,
    String? paymentType,
    bool? isPaid,
    bool? isDelivered,
    String? state,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? orderNumber,
    num? v,
    OrderStoreEntity? store,
    ShippingAddressEntity? shippingAddress,
    DateTime? paidAt,
    OrderStatusEnum? orderStatus,
    Position? currentLocation,
  }) {
    return OrderEntity(
      id: id ?? this.id,
      user: user ?? this.user,
      orderItems: orderItems ?? this.orderItems,
      totalPrice: totalPrice ?? this.totalPrice,
      paymentType: paymentType ?? this.paymentType,
      isPaid: isPaid ?? this.isPaid,
      isDelivered: isDelivered ?? this.isDelivered,
      state: state ?? this.state,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      orderNumber: orderNumber ?? this.orderNumber,
      v: v ?? this.v,
      store: store ?? this.store,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      paidAt: paidAt ?? this.paidAt,
      orderStatus: orderStatus ?? this.orderStatus,
      currentLocation: currentLocation ?? this.currentLocation,
    );
  }


  OrderDataResponse toModel() {
    return OrderDataResponse(
      id: id,
      user: user.toModel(),
      orderItems: orderItems.map((e) => e.toModel()).toList(),
      totalPrice: totalPrice,
      paymentType: paymentType,
      isPaid: isPaid,
      isDelivered: isDelivered,
      state: state,
      createdAt: createdAt,
      updatedAt: updatedAt,
      orderNumber: orderNumber,
      v: v,
      store: store.toModel(),
      shippingAddress: shippingAddress.toModel(),
      paidAt: paidAt,
      orderStatus: orderStatus.name,
      currentLocation: currentLocation != null
          ? {
              'latitude': currentLocation!.latitude,
              'longitude': currentLocation!.longitude,
            }
          : null,
    );
  }


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
    orderStatus,
    currentLocation,
  ];
}
