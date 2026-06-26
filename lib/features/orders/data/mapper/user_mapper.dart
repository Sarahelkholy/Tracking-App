import '../../domain/entities/order_user_entity.dart';
import '../models/responses/orders_response/user_response.dart';

extension UserResponseMapper on UserResponse {
  OrderUserEntity toEntity() {
    return OrderUserEntity(
      id: id ?? '',
      firstName: firstName ?? '',
      lastName: lastName ?? '',
      email: email ?? '',
      gender: gender ?? '',
      phone: phone ?? '',
      photo: photo ?? '',
      passwordChangedAt:
          passwordChangedAt ?? DateTime.fromMillisecondsSinceEpoch(0),
      resetCodeVerified: resetCodeVerified ?? false,
    );
  }
}
