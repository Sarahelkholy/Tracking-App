import 'package:flower_driver/config/driver/manager/driver_cubit.dart';
import 'package:flower_driver/config/route_manager/routes.dart';
import 'package:flower_driver/features/orders/presentation/mangers/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../mangers/home_cubit.dart';
import '../mangers/home_event.dart';
import '../widgets/order_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeCubit _homeCubit;

  @override
  void initState() {
    super.initState();

    _homeCubit = context.read<HomeCubit>();
    _homeCubit.doIntent(GetPendingOrders());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<HomeCubit, HomeState>(
        buildWhen: (previous, current) =>
            previous.pendingOrdersState != current.pendingOrdersState,
        builder: (BuildContext context, HomeState state) {
          if (state.pendingOrdersState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.pendingOrdersState.errorMessage != null) {
            return Center(child: Text(state.pendingOrdersState.errorMessage!));
          }
          final orders = state.pendingOrdersState.data?.orders;
          if (orders == null || orders.isEmpty) {
            return const Center(child: Text('No pending orders available'));
          }
          return SafeArea(
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return OrderCard(
                  storeName: order.store.name,
                  storeAddress: order.shippingAddress.address,
                  userName: order.user.firstName,
                  userAddress: '20th st, Sheikh Zayed, Giza',
                  price: order.totalPrice.toString(),
                  onAccept: () {
                    final driverId = context
                        .read<DriverCubit>()
                        .state
                        .driver
                        ?.id;
                    _homeCubit.doIntent(
                      SelectOrder(
                        selectedOrder: order,
                        driverId: driverId ?? "",
                      ),
                    );
                  },
                  onReject: () {},
                );
              },
            ),
          );
        },
        listenWhen: (previous, current) =>
            previous.selectedOrder != current.selectedOrder,
        listener: (BuildContext context, HomeState state) {
          if (state.selectedOrder.isSuccess) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.activeOrderDetails,
              (route) => false,
            );
          }
        },
      ),
    );
  }
}
