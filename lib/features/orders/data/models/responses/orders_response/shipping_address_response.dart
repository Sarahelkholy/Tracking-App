import 'package:json_annotation/json_annotation.dart';

part 'shipping_address_response.g.dart';

@JsonSerializable()
class ShippingAddressResponse {
  @JsonKey(name: "street")
  String? street;
  @JsonKey(name: "city")
  String? city;
  @JsonKey(name: "phone")
  String? phone;
  @JsonKey(name: "lat")
  String? lat;
  @JsonKey(name: "long")
  String? long;

  ShippingAddressResponse({
    this.street,
    this.city,
    this.phone,
    this.lat,
    this.long,
  });

  factory ShippingAddressResponse.fromJson(Map<String, dynamic> json) =>
      _$ShippingAddressResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ShippingAddressResponseToJson(this);
}
