import '../../domain/entities/enums/order_status_enum.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_store_entity.dart';
import '../../domain/entities/order_user_entity.dart';
import '../../domain/entities/shipping_address_entity.dart';
import '../models/responses/orders_response/order_data_response.dart';
import 'order_item_mapper.dart';
import 'shipping_address_mapper.dart';
import 'store_mapper.dart';
import 'user_mapper.dart';

extension OrderDataResponseMapper on OrderDataResponse {
  OrderEntity toEntity() {
    return OrderEntity(
      id: id ?? '',
      user:
          user?.toEntity() ??
          OrderUserEntity(
            id: '',
            firstName: '',
            lastName: '',
            email: '',
            gender: '',
            phone: '',
            photo: '',
            passwordChangedAt: DateTime.fromMillisecondsSinceEpoch(0),
            resetCodeVerified: false,
          ),
      orderItems: orderItems?.map((e) => e.toEntity()).toList() ?? [],
      totalPrice: totalPrice ?? 0,
      paymentType: paymentType ?? '',
      isPaid: isPaid ?? false,
      isDelivered: isDelivered ?? false,
      state: state ?? '',
      createdAt: createdAt ?? DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt: updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0),
      orderNumber: orderNumber ?? '',
      v: v ?? 0,
      store:
          store?.toEntity() ??
          const OrderStoreEntity(
            name: '',
            image: '',
            address: '',
            phoneNumber: '',
            latLong: '',
          ),
      shippingAddress:
          shippingAddress?.toEntity() ??
          const ShippingAddressEntity(
            street: '',
            city: '',
            phone: '',
            lat: '',
            long: '',
          ),
      paidAt: paidAt ?? DateTime.fromMillisecondsSinceEpoch(0),
        orderStatus: orderStatus != null
          ? OrderStatusEnumHelper.fromString(orderStatus!)
          : OrderStatusEnum.pending,
    );
  }
}
