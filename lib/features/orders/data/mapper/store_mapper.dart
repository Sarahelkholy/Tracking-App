import '../../domain/entities/order_store_entity.dart';
import '../models/responses/orders_response/store_response.dart';

extension StoreResponseMapper on StoreResponse {
  OrderStoreEntity toEntity() {
    return OrderStoreEntity(
      name: name ?? '',
      image: image ?? '',
      address: address ?? '',
      phoneNumber: phoneNumber ?? '',
      latLong: latLong ?? '',
    );
  }
}
