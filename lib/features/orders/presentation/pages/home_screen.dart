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
          return SafeArea(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return OrderCard(
                  storeName:
                      state.pendingOrdersState.data!.orders[index].store.name,
                  storeAddress: state
                      .pendingOrdersState
                      .data!
                      .orders[index]
                      .shippingAddress
                      .address,
                  userName: state
                      .pendingOrdersState
                      .data!
                      .orders[index]
                      .user
                      .firstName,
                  userAddress: '20th st, Sheikh Zayed, Giza',
                  price: state.pendingOrdersState.data!.orders[index].totalPrice
                      .toString(),
                  onAccept: () {
                    _homeCubit.doIntent(
                      SelectOrder(
                        selectedOrder:
                            state.pendingOrdersState.data!.orders[index],
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
