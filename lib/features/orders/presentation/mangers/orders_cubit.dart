import 'package:flower_driver/config/base_state/base_state.dart';
import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/orders/domain/entities/order_entity.dart';
import 'package:flower_driver/features/orders/domain/entities/orders_entity.dart';
import 'package:flower_driver/features/orders/domain/use_cases/get_all_driver_orders_use_case.dart';
import 'package:flower_driver/features/orders/presentation/mangers/orders_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class OrdersCubit extends Cubit<OrdersState> {
  final GetAllDriverOrdersUseCase _getAllDriverOrdersUseCase;

  OrdersCubit(this._getAllDriverOrdersUseCase) : super(const OrdersState());

  Future<void> getOrders({bool isRefresh = false}) async {
    if (state.ordersState.isLoading) return;

    if (isRefresh) {
      emit(state.copyWith(
        page: 0,
        totalPages: 1,
        ordersState: const BaseState<OrdersEntity>(),
      ));
    }

    final int pageToFetch = state.page + 1;

    if (state.page != 0 && pageToFetch > state.totalPages) {
      return;
    }

    final OrdersEntity? currentData = state.ordersState.data;

    emit(
      state.copyWith(
        ordersState: BaseState<OrdersEntity>(
          data: currentData,
          errorMessage: null,
          isSuccess: false,
          isLoading: true,
        ),
      ),
    );

    var response = await _getAllDriverOrdersUseCase(pageToFetch, 10);
    switch (response) {
      case Success<OrdersEntity>():
        final List<OrderEntity> allOrders = [
          ...(isRefresh ? [] : (currentData?.orders ?? [])),
          ...response.data.orders,
        ];

        emit(
          state.copyWith(
            ordersState: BaseState<OrdersEntity>(
              data: OrdersEntity(
                message: response.data.message,
                metadata: response.data.metadata,
                orders: allOrders,
              ),
              errorMessage: null,
              isSuccess: true,
              isLoading: false,
            ),
            page: pageToFetch,
            totalPages: response.data.metadata.totalPages.toInt(),
          ),
        );
      case Failure<OrdersEntity>():
        emit(
          state.copyWith(
            ordersState: BaseState<OrdersEntity>(
              data: currentData,
              errorMessage: response.errorMessage,
              isSuccess: false,
              isLoading: false,
            ),
          ),
        );
    }
  }
}
