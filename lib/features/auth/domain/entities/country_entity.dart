import 'package:equatable/equatable.dart';

class CountryEntity extends Equatable {
  final String name;
  final String code;
  final String flagUrl;

  const CountryEntity({
    required this.name,
    required this.code,
    required this.flagUrl,
  });

  @override
  List<Object?> get props => [name, code, flagUrl];
}
