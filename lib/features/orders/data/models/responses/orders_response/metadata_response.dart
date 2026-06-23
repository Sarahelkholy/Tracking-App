import 'package:json_annotation/json_annotation.dart';

part 'metadata_response.g.dart';

@JsonSerializable()
class MetadataResponse {
  @JsonKey(name: "currentPage")
  num? currentPage;
  @JsonKey(name: "totalPages")
  num? totalPages;
  @JsonKey(name: "totalItems")
  num? totalItems;
  @JsonKey(name: "limit")
  num? limit;

  MetadataResponse({
    this.currentPage,
    this.totalPages,
    this.totalItems,
    this.limit,
  });

  factory MetadataResponse.fromJson(Map<String, dynamic> json) =>
      _$MetadataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MetadataResponseToJson(this);
}
