import 'package:injectable/injectable.dart';
import '../../../../config/error_handling/result.dart';
import '../../domain/entities/orders_entity.dart';
import '../../domain/repositories/orders_repo.dart';
import '../data_source/remote/orders_remote_data_source.dart';
import '../mapper/orders_mapper.dart';
import '../models/responses/orders_response/orders_response.dart';

@Injectable(as: OrdersRepo)
class OrdersRepoImpl implements OrdersRepo {
  final OrdersRemoteDataSource _ordersRemoteDataSource;

  OrdersRepoImpl(this._ordersRemoteDataSource);

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
}
