import 'package:json_annotation/json_annotation.dart';
import 'order_item_response.dart';
import 'shipping_address_response.dart';
import 'store_response.dart';
import 'user_response.dart';

part 'order_data_response.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderDataResponse {
  @JsonKey(name: "_id")
  String? id;
  @JsonKey(name: "user")
  UserResponse? user;
  @JsonKey(name: "orderItems")
  List<OrderItemResponse>? orderItems;
  @JsonKey(name: "totalPrice")
  num? totalPrice;
  @JsonKey(name: "paymentType")
  String? paymentType;
  @JsonKey(name: "isPaid")
  bool? isPaid;
  @JsonKey(name: "isDelivered")
  bool? isDelivered;
  @JsonKey(name: "state")
  String? state;
  @JsonKey(name: "createdAt")
  DateTime? createdAt;
  @JsonKey(name: "updatedAt")
  DateTime? updatedAt;
  @JsonKey(name: "orderNumber")
  String? orderNumber;
  @JsonKey(name: "__v")
  num? v;
  @JsonKey(name: "store")
  StoreResponse? store;
  @JsonKey(name: "shippingAddress")
  ShippingAddressResponse? shippingAddress;
  @JsonKey(name: "paidAt")
  DateTime? paidAt;
  @JsonKey(name: 'orderStatus')
  String? orderStatus;
  @JsonKey(name: 'currentLocation')
  Map<String, dynamic>? currentLocation;

  OrderDataResponse({
    this.id,
    this.user,
    this.orderItems,
    this.totalPrice,
    this.paymentType,
    this.isPaid,
    this.isDelivered,
    this.state,
    this.createdAt,
    this.updatedAt,
    this.orderNumber,
    this.v,
    this.store,
    this.shippingAddress,
    this.paidAt,
    this.orderStatus,
    this.currentLocation,
  });

  factory OrderDataResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderDataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDataResponseToJson(this);
}
