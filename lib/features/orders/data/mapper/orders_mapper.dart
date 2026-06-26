import '../../domain/entities/orders_entity.dart';
import '../../domain/entities/orders_metadata_entity.dart';
import '../models/responses/orders_response/orders_response.dart';
import 'metadata_mapper.dart';
import 'order_data_mapper.dart';

extension OrdersResponseMapper on OrdersResponse {
  OrdersEntity toEntity() {
    return OrdersEntity(
      message: message ?? '',
      metadata:
          metadata?.toEntity() ??
          const OrdersMetadataEntity(
            currentPage: 0,
            totalPages: 0,
            totalItems: 0,
            limit: 0,
          ),
      orders: orders?.map((e) => e.toEntity()).toList() ?? [],
    );
  }
}
