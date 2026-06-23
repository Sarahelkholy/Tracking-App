import 'package:json_annotation/json_annotation.dart';
import 'product_response.dart';

part 'order_item_response.g.dart';

@JsonSerializable()
class OrderItemResponse {
  @JsonKey(name: "product")
  ProductResponse? product;
  @JsonKey(name: "price")
  num? price;
  @JsonKey(name: "quantity")
  num? quantity;
  @JsonKey(name: "_id")
  String? id;

  OrderItemResponse({this.product, this.price, this.quantity, this.id});

  factory OrderItemResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderItemResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemResponseToJson(this);
}
