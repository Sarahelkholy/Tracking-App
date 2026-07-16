import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import '../../../core/values/api_end_points.dart';
import '../data/models/responses/orders_response/driver_order_response.dart';
import '../data/models/responses/orders_response/orders_response.dart';

part 'orders_api_client.g.dart';

@injectable
@RestApi()
abstract class OrdersApiClient {
  @factoryMethod
  factory OrdersApiClient(Dio dio) = _OrdersApiClient;

  @GET(ApiEndPoints.pendingOrders)
  Future<OrdersResponse> getAllPendingOrders(
    @Query('page') int page,
    @Query('limit') int limit,
  );

  @GET(ApiEndPoints.driverOrders)
  Future<DriverOrderResponse> getAllDriverOrders(
    @Query('page') int page,
    @Query('limit') int limit,
  );


  @PUT("${ApiEndPoints.updateOrderState}{orderId}")
  Future<void> updateOrderState(
    @Path("orderId") String orderId,
    @Body() Map<String, dynamic> body,
  );
}
