import '../../domain/entities/shipping_address_entity.dart';
import '../models/responses/orders_response/shipping_address_response.dart';

extension ShippingAddressResponseMapper on ShippingAddressResponse {
  ShippingAddressEntity toEntity() {
    return ShippingAddressEntity(
      street: street ?? '',
      city: city ?? '',
      phone: phone ?? '',
      lat: lat ?? '',
      long: long ?? '',
    );
  }
}
