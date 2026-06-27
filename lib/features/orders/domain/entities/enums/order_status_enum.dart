enum OrderStatusEnum {
  pending,
  accepted,
  picked,
  outForDelivery,
  arrived,
  delivered,
}

extension OrderStatusEnumHelper on OrderStatusEnum {
  static OrderStatusEnum fromString(String value) {
    return OrderStatusEnum.values.firstWhere(
      (status) => status.name == value,
      orElse: () => OrderStatusEnum.pending,
    );
  }
}
