import 'package:flower_driver/config/firebase/firestore_field_name.dart';
import 'package:flower_driver/features/orders/data/mapper/order_data_mapper.dart';
import 'package:flower_driver/features/orders/domain/entities/order_entity.dart';
import 'package:injectable/injectable.dart';

import '../../../../config/error_handling/result.dart';
import '../../../../config/firebase/firebase_service.dart';
import '../../../../config/firebase/firestore_collection.dart';
import '../../domain/entities/orders_entity.dart';
import '../../domain/repositories/orders_repo.dart';
import '../data_source/remote/orders_remote_data_source.dart';
import '../mapper/orders_mapper.dart';
import '../models/responses/orders_response/order_data_response.dart';
import '../models/responses/orders_response/orders_response.dart';

@Injectable(as: OrdersRepo)
class OrdersRepoImpl implements OrdersRepo {
  final OrdersRemoteDataSource _ordersRemoteDataSource;
  final FirebaseService _firebaseService;

  OrdersRepoImpl(this._ordersRemoteDataSource, this._firebaseService);

  @override
  Future<Result<OrdersEntity>> getAllPendingOrders() async {
    final response = await _ordersRemoteDataSource.getAllPendingOrders();

    switch (response) {
      case Success<OrdersResponse>():
        return Success<OrdersEntity>(data: response.data.toEntity());
      case Failure<OrdersResponse>():
        return Failure<OrdersEntity>(errorMessage: response.errorMessage);
    }
  }

  @override
  Future<OrderEntity?> getParsedDoc(String path, String field) async {
    final data = await _firebaseService.getCollectionWhere(
      path: FireStoreCollection.orderCollectionPath,
      field: FireStoreFieldName.orderStatus,
    );

    if (data.isEmpty) {
      print("firestore model is empty");
      return null;
    }

    print("firestore model is not empty");
    return OrderDataResponse.fromJson(data).toEntity();
  }
}
