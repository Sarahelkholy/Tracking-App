import 'package:equatable/equatable.dart';

class OrdersMetadataEntity extends Equatable {
  final num currentPage;
  final num totalPages;
  final num totalItems;
  final num limit;

  const OrdersMetadataEntity({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.limit,
  });

  @override
  List<Object?> get props => [currentPage, totalPages, totalItems, limit];
}
