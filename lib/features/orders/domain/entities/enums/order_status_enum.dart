enum OrderStatusEnum {
  pending,
  accepted,
  picked,
  outForDelivery,
  arrived,
  delivered,
  completed,
}

extension OrderStatusEnumHelper on OrderStatusEnum {
  static OrderStatusEnum fromString(String value) {
    return OrderStatusEnum.values.firstWhere(
      (status) => status.name == value,
      orElse: () => OrderStatusEnum.pending,
    );
  }

  OrderStatusEnum? get nextStatus {
    switch (this) {
      case OrderStatusEnum.accepted:
        return OrderStatusEnum.picked;
      case OrderStatusEnum.picked:
        return OrderStatusEnum.outForDelivery;
      case OrderStatusEnum.outForDelivery:
        return OrderStatusEnum.arrived;
      case OrderStatusEnum.arrived:
        return OrderStatusEnum.delivered;
      default:
        return null;
    }
  }

  bool? get isActiveNext {
    if (this == OrderStatusEnum.arrived) return true;
    if (nextStatus != null) return true;
    return null;
  }
}
