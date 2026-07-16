import 'package:json_annotation/json_annotation.dart';
import 'metadata_response.dart';
import 'order_data_response.dart';
import 'store_response.dart';

part 'driver_order_response.g.dart';

@JsonSerializable(explicitToJson: true)
class DriverOrderResponse {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "metadata")
  MetadataResponse? metadata;
  @JsonKey(name: "orders")
  List<DriverOrderDataResponse>? orders;

  DriverOrderResponse({this.message, this.metadata, this.orders});

  factory DriverOrderResponse.fromJson(Map<String, dynamic> json) =>
      _$DriverOrderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DriverOrderResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class DriverOrderDataResponse {
  @JsonKey(name: "_id")
  String? id;
  @JsonKey(name: "driver")
  String? driver;
  @JsonKey(name: "order")
  OrderDataResponse? order;
  @JsonKey(name: "__v")
  num? v;
  @JsonKey(name: "createdAt")
  DateTime? createdAt;
  @JsonKey(name: "updatedAt")
  DateTime? updatedAt;
  @JsonKey(name: "store")
  StoreResponse? store;

  DriverOrderDataResponse({
    this.id,
    this.driver,
    this.order,
    this.v,
    this.createdAt,
    this.updatedAt,
    this.store,
  });

  factory DriverOrderDataResponse.fromJson(Map<String, dynamic> json) =>
      _$DriverOrderDataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DriverOrderDataResponseToJson(this);
}
