import '../../domain/entities/order_item_entity.dart';
import '../../domain/entities/order_product_entity.dart';
import '../models/responses/orders_response/order_item_response.dart';
import 'product_mapper.dart';

extension OrderItemResponseMapper on OrderItemResponse {
  OrderItemEntity toEntity() {
    return OrderItemEntity(
      id: id ?? '',
      product:
          product?.toEntity() ??
          OrderProductEntity(
            id: '',
            title: '',
            slug: '',
            description: '',
            imgCover: '',
            images: const [],
            price: 0,
            priceAfterDiscount: 0,
            discount: 0,
            rateAvg: 0,
            rateCount: 0,
            sold: 0,
            quantity: 0,
            category: '',
            occasion: '',
            isSuperAdmin: false,
            createdAt: DateTime.fromMillisecondsSinceEpoch(0),
            updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
            v: 0,
          ),
      price: price ?? 0,
      quantity: quantity ?? 0,
    );
  }
}
