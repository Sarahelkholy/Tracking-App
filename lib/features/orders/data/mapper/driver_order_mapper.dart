import '../../domain/entities/orders_entity.dart';
import '../../domain/entities/orders_metadata_entity.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_store_entity.dart';
import '../../domain/entities/order_user_entity.dart';
import '../../domain/entities/shipping_address_entity.dart';
import '../../domain/entities/enums/order_status_enum.dart';
import '../models/responses/orders_response/driver_order_response.dart';
import 'metadata_mapper.dart';
import 'order_item_mapper.dart';
import 'shipping_address_mapper.dart';
import 'store_mapper.dart';
import 'user_mapper.dart';

extension DriverOrderResponseMapper on DriverOrderResponse {
  OrdersEntity toEntity() {
    return OrdersEntity(
      message: message ?? '',
      metadata: metadata?.toEntity() ??
          const OrdersMetadataEntity(
            currentPage: 0,
            totalPages: 0,
            totalItems: 0,
            limit: 0,
          ),
      orders: orders?.map((e) => e.toEntity()).toList() ?? [],
    );
  }
}

extension DriverOrderDataResponseMapper on DriverOrderDataResponse {
  OrderEntity toEntity() {
    final o = order;
    return OrderEntity(
      id: o?.id ?? '',
      user: o?.user?.toEntity() ??
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
      orderItems: o?.orderItems?.map((e) => e.toEntity()).toList() ?? [],
      totalPrice: o?.totalPrice ?? 0,
      paymentType: o?.paymentType ?? '',
      isPaid: o?.isPaid ?? false,
      isDelivered: o?.isDelivered ?? false,
      state: o?.state ?? '',
      createdAt: o?.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt: o?.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0),
      orderNumber: o?.orderNumber ?? '',
      v: o?.v ?? 0,
      store: store?.toEntity() ??
          const OrderStoreEntity(
            name: '',
            image: '',
            address: '',
            phoneNumber: '',
            latLong: '',
          ),
      shippingAddress: o?.shippingAddress?.toEntity() ??
          const ShippingAddressEntity(
            street: '',
            city: '',
            phone: '',
            lat: '',
            long: '',
          ),
      paidAt: o?.paidAt ?? DateTime.fromMillisecondsSinceEpoch(0),
      orderStatus: o?.orderStatus != null
          ? OrderStatusEnumHelper.fromString(o!.orderStatus!)
          : OrderStatusEnum.pending,
    );
  }
}
