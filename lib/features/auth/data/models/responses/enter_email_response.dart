import 'package:json_annotation/json_annotation.dart';

part 'enter_email_response.g.dart';

@JsonSerializable()
class EnterEmailResponse {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "info")
  String? info;

  EnterEmailResponse({this.message, this.info});

  factory EnterEmailResponse.fromJson(Map<String, dynamic> json) =>
      _$EnterEmailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EnterEmailResponseToJson(this);
}
