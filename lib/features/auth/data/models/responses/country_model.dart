import 'package:json_annotation/json_annotation.dart';

part 'country_model.g.dart';

@JsonSerializable()
class CountryModel {
    @JsonKey(name: "isoCode")
    final String? isoCode;
    @JsonKey(name: "name")
    final String? name;
    @JsonKey(name: "phoneCode")
    final String? phoneCode;
    @JsonKey(name: "flag")
    final String? flag;
    @JsonKey(name: "currency")
    final String? currency;
    @JsonKey(name: "latitude")
    final String? latitude;
    @JsonKey(name: "longitude")
    final String? longitude;
    @JsonKey(name: "timezones")
    final List<Timezone>? timezones;

    CountryModel({
        this.isoCode,
        this.name,
        this.phoneCode,
        this.flag,
        this.currency,
        this.latitude,
        this.longitude,
        this.timezones,
    });

    CountryModel copyWith({
        String? isoCode,
        String? name,
        String? phoneCode,
        String? flag,
        String? currency,
        String? latitude,
        String? longitude,
        List<Timezone>? timezones,
    }) => 
        CountryModel(
            isoCode: isoCode ?? this.isoCode,
            name: name ?? this.name,
            phoneCode: phoneCode ?? this.phoneCode,
            flag: flag ?? this.flag,
            currency: currency ?? this.currency,
            latitude: latitude ?? this.latitude,
            longitude: longitude ?? this.longitude,
            timezones: timezones ?? this.timezones,
        );

    factory CountryModel.fromJson(Map<String, dynamic> json) => _$CountryModelFromJson(json);

    Map<String, dynamic> toJson() => _$CountryModelToJson(this);
}

@JsonSerializable()
class Timezone {
    @JsonKey(name: "zoneName")
    final String? zoneName;
    @JsonKey(name: "gmtOffset")
    final int? gmtOffset;
    @JsonKey(name: "gmtOffsetName")
    final String? gmtOffsetName;
    @JsonKey(name: "abbreviation")
    final String? abbreviation;
    @JsonKey(name: "tzName")
    final String? tzName;

    Timezone({
        this.zoneName,
        this.gmtOffset,
        this.gmtOffsetName,
        this.abbreviation,
        this.tzName,
    });

    Timezone copyWith({
        String? zoneName,
        int? gmtOffset,
        String? gmtOffsetName,
        String? abbreviation,
        String? tzName,
    }) => 
        Timezone(
            zoneName: zoneName ?? this.zoneName,
            gmtOffset: gmtOffset ?? this.gmtOffset,
            gmtOffsetName: gmtOffsetName ?? this.gmtOffsetName,
            abbreviation: abbreviation ?? this.abbreviation,
            tzName: tzName ?? this.tzName,
        );

    factory Timezone.fromJson(Map<String, dynamic> json) => _$TimezoneFromJson(json);

    Map<String, dynamic> toJson() => _$TimezoneToJson(this);
}
