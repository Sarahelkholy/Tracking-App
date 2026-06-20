import 'package:json_annotation/json_annotation.dart';

part 'new_password_response.g.dart';

@JsonSerializable()
class NewPasswordResponse {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "token")
  String? token;

  NewPasswordResponse({this.message, this.token});

  factory NewPasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$NewPasswordResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NewPasswordResponseToJson(this);
}
