import 'package:json_annotation/json_annotation.dart';
import 'metadata_response.dart';
import 'order_data_response.dart';

part 'orders_response.g.dart';

@JsonSerializable()
class OrdersResponse {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "metadata")
  MetadataResponse? metadata;
  @JsonKey(name: "orders")
  List<OrderDataResponse>? orders;

  OrdersResponse({this.message, this.metadata, this.orders});

  factory OrdersResponse.fromJson(Map<String, dynamic> json) =>
      _$OrdersResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrdersResponseToJson(this);
}
