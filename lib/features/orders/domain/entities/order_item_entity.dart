import 'package:equatable/equatable.dart';
import '../../data/models/responses/orders_response/order_item_response.dart';
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

  OrderItemResponse toModel() {
    return OrderItemResponse(
      id: id,
      product: product.toModel(),
      price: price,
      quantity: quantity,
    );
  }

  @override
  List<Object?> get props => [product, price, quantity, id];
}
