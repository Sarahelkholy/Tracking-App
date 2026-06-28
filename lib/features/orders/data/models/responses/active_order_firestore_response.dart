import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flower_driver/features/orders/data/models/responses/orders_response/order_item_response.dart';
import 'package:flower_driver/features/orders/data/models/responses/orders_response/shipping_address_response.dart';
import 'package:flower_driver/features/orders/data/models/responses/orders_response/store_response.dart';
import 'package:flower_driver/features/orders/data/models/responses/orders_response/user_response.dart';

class ActiveOrderFirestoreResponse {
  final String? id;
  final UserResponse? user;
  final List<OrderItemResponse>? orderItems;
  final num? totalPrice;
  final String? paymentType;
  final bool? isPaid;
  final bool? isDelivered;
  final String? state;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? orderNumber;
  final num? v;
  final StoreResponse? store;
  final ShippingAddressResponse? shippingAddress;
  final DateTime? paidAt;
  final String? orderStatus;
  final String? driverId;
  final Map<String, dynamic>? currentLocation;
  final bool? isActive;

  ActiveOrderFirestoreResponse({
    this.id,
    this.user,
    this.orderItems,
    this.totalPrice,
    this.paymentType,
    this.isPaid,
    this.isDelivered,
    this.state,
    this.createdAt,
    this.updatedAt,
    this.orderNumber,
    this.v,
    this.store,
    this.shippingAddress,
    this.paidAt,
    this.orderStatus,
    this.driverId,
    this.currentLocation,
    this.isActive,
  });

  factory ActiveOrderFirestoreResponse.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      if (value is Timestamp) return value.toDate();
      if (value is String) return DateTime.tryParse(value);
      return null;
    }

    return ActiveOrderFirestoreResponse(
      id: json['_id'] as String? ?? json['id'] as String?,
      user: json['user'] == null
          ? null
          : UserResponse.fromJson(json['user'] as Map<String, dynamic>),
      orderItems: (json['orderItems'] as List<dynamic>?)
          ?.map((e) => OrderItemResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPrice: json['totalPrice'] as num?,
      paymentType: json['paymentType'] as String?,
      isPaid: json['isPaid'] as bool?,
      isDelivered: json['isDelivered'] as bool?,
      state: json['state'] as String?,
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
      orderNumber: json['orderNumber'] as String?,
      v: json['__v'] as num?,
      store: json['store'] == null
          ? null
          : StoreResponse.fromJson(json['store'] as Map<String, dynamic>),
      shippingAddress: json['shippingAddress'] == null
          ? null
          : ShippingAddressResponse.fromJson(
              json['shippingAddress'] as Map<String, dynamic>,
            ),
      paidAt: parseDate(json['paidAt']),
      orderStatus: json['orderStatus'] as String?,
      driverId: json['driverId'] as String?,
      currentLocation: json['currentLocation'] as Map<String, dynamic>?,
      isActive: json['isActive'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user?.toJson(),
      'orderItems': orderItems?.map((e) => e.toJson()).toList(),
      'totalPrice': totalPrice,
      'paymentType': paymentType,
      'isPaid': isPaid,
      'isDelivered': isDelivered,
      'state': state,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'orderNumber': orderNumber,
      '__v': v,
      'store': store?.toJson(),
      'shippingAddress': shippingAddress?.toJson(),
      'paidAt': paidAt?.toIso8601String(),
      'orderStatus': orderStatus,
      'driverId': driverId,
      'currentLocation': currentLocation,
      'isActive': isActive,
    };
  }
}
