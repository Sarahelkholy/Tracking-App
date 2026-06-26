import 'package:equatable/equatable.dart';
import '../../data/models/responses/orders_response/shipping_address_response.dart';

class ShippingAddressEntity extends Equatable {
  final String street;
  final String city;
  final String phone;
  final String lat;
  final String long;

  const ShippingAddressEntity({
    required this.street,
    required this.city,
    required this.phone,
    required this.lat,
    required this.long,
  });

  @override
  List<Object?> get props => [street, city, phone, lat, long];

  String get address => '$street, $city';

  ShippingAddressResponse toModel() {
    return ShippingAddressResponse(
      street: street,
      city: city,
      phone: phone,
      lat: lat,
      long: long,
    );
  }
}
