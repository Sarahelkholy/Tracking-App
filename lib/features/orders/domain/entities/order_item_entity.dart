import 'package:equatable/equatable.dart';
import 'order_product_entity.dart';

class OrderItemEntity extends Equatable {
  final OrderProductEntity product;
  final num price;
  final num quantity;
  final String id;

  const OrderItemEntity({
    required this.product,
    required this.price,
    required this.quantity,
    required this.id,
  });

  @override
  List<Object?> get props => [product, price, quantity, id];
}
