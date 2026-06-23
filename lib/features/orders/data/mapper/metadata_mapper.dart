import '../../domain/entities/orders_metadata_entity.dart';
import '../models/responses/orders_response/metadata_response.dart';

extension MetadataResponseMapper on MetadataResponse {
  OrdersMetadataEntity toEntity() {
    return OrdersMetadataEntity(
      currentPage: currentPage ?? 0,
      totalPages: totalPages ?? 0,
      totalItems: totalItems ?? 0,
      limit: limit ?? 0,
    );
  }
}
