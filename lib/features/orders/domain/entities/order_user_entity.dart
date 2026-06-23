import 'package:equatable/equatable.dart';

class OrderUserEntity extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String gender;
  final String phone;
  final String photo;
  final DateTime passwordChangedAt;
  final bool resetCodeVerified;

  const OrderUserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.gender,
    required this.phone,
    required this.photo,
    required this.passwordChangedAt,
    required this.resetCodeVerified,
  });

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    email,
    gender,
    phone,
    photo,
    passwordChangedAt,
    resetCodeVerified,
  ];
}
