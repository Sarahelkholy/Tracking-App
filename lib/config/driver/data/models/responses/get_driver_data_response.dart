import 'package:json_annotation/json_annotation.dart';
import 'driver_response.dart';

part 'get_driver_data_response.g.dart';

@JsonSerializable(explicitToJson: true)
class GetDriverDataResponse {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "driver")
  DriverResponse? driver;

  GetDriverDataResponse({this.message, this.driver});

  factory GetDriverDataResponse.fromJson(Map<String, dynamic> json) =>
      _$GetDriverDataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetDriverDataResponseToJson(this);
}
