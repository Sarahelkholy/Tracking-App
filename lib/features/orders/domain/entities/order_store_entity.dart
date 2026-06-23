import 'package:equatable/equatable.dart';

class OrderStoreEntity extends Equatable {
  final String name;
  final String image;
  final String address;
  final String phoneNumber;
  final String latLong;

  const OrderStoreEntity({
    required this.name,
    required this.image,
    required this.address,
    required this.phoneNumber,
    required this.latLong,
  });

  @override
  List<Object?> get props => [name, image, address, phoneNumber, latLong];
}
