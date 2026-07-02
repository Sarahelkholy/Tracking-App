import '../../domain/entities/order_product_entity.dart';
import '../models/responses/orders_response/product_response.dart';

extension ProductResponseMapper on ProductResponse {
  OrderProductEntity toEntity() {
    return OrderProductEntity(
      id: id ?? '',
      title: title ?? '',
      slug: slug ?? '',
      description: description ?? '',
      imgCover: imgCover ?? '',
      images: images ?? [],
      price: price ?? 0,
      priceAfterDiscount: priceAfterDiscount ?? 0,
      discount: discount ?? 0,
      rateAvg: rateAvg ?? 0,
      rateCount: rateCount ?? 0,
      sold: sold ?? 0,
      quantity: quantity ?? 0,
      category: category ?? '',
      occasion: occasion ?? '',
      isSuperAdmin: isSuperAdmin ?? false,
      createdAt: createdAt ?? DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt: updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0),
      v: v ?? 0,
    );
  }
}
