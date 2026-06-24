enum OrderStatusEnum {
  pending,
  accepted,
  picked,
  outForDelivery,
  arrived,
  delivered,
}

extension OrderStatusExtension on OrderStatusEnum {
  String get displayName {
    switch (this) {
      case OrderStatusEnum.pending:
        return 'Pending';
      case OrderStatusEnum.accepted:
        return 'Accepted';
      case OrderStatusEnum.picked:
        return 'Picked';
      case OrderStatusEnum.outForDelivery:
        return 'Out for Delivery';
      case OrderStatusEnum.arrived:
        return 'Arrived';
      case OrderStatusEnum.delivered:
        return 'Delivered';
    }
  }

  static OrderStatusEnum fromString(String value) {
    return OrderStatusEnum.values.firstWhere(
          (status) => status.name == value,
      orElse: () => OrderStatusEnum.pending,
    );
  }
}