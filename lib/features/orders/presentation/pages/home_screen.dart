import 'package:flower_driver/config/driver/manager/driver_cubit.dart';
import 'package:flower_driver/config/route_manager/routes.dart';
import 'package:flower_driver/features/orders/domain/entities/order_entity.dart';
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
  late ScrollController _scrollController;
  final Set<String> _rejectedOrderIds = {};

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _homeCubit = context.read<HomeCubit>();
    _homeCubit.doIntent(GetPendingOrders());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_homeCubit.state.pendingOrdersState.isLoading) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    const threshold = 200.0;

    if (maxScroll - currentScroll <= threshold) {
      _homeCubit.doIntent(GetPendingOrders());
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _rejectedOrderIds.clear();
    });
    _homeCubit.doIntent(GetPendingOrders(isRefresh: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<HomeCubit, HomeState>(
        listenWhen: (previous, current) =>
            previous.selectedOrder != current.selectedOrder,
        listener: (context, state) {
          if (state.selectedOrder.isSuccess) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.activeOrderDetails,
              (route) => false,
            );
          }
        },
        buildWhen: (previous, current) =>
            previous.pendingOrdersState != current.pendingOrdersState,
        builder: (context, state) {
          final orders = state.pendingOrdersState.data?.orders ?? [];
          final visibleOrders = orders
              .where((o) => !_rejectedOrderIds.contains(o.id))
              .toList();

          if (state.pendingOrdersState.isLoading && visibleOrders.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return SafeArea(
            child: RefreshIndicator(
              onRefresh: _handleRefresh,
              child: visibleOrders.isEmpty
                  ? _buildEmptyState(state.pendingOrdersState.errorMessage)
                  : _buildOrdersList(state, visibleOrders),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(String? errorMessage) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    errorMessage ?? "No pending orders found.",
                    textAlign: TextAlign.center,
                    style: errorMessage != null
                        ? const TextStyle(color: Colors.red)
                        : null,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        _homeCubit.doIntent(GetPendingOrders(isRefresh: true)),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrdersList(HomeState state, List<OrderEntity> visibleOrders) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: visibleOrders.length +
          (state.pendingOrdersState.isLoading ? 1 : 0),
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        if (index == visibleOrders.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return _buildOrderCard(context, visibleOrders[index]);
      },
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderEntity order) {
    return OrderCard(
      storeImage: order.store.image,
      userImage: order.user.photo,
      storeName: order.store.name,
      storeAddress: order.shippingAddress.address,
      userName: order.user.firstName,
      userAddress: '20th st, Sheikh Zayed, Giza',
      price: order.totalPrice.toString(),
      onAccept: () {
        final driverId = context.read<DriverCubit>().state.driver?.id;
        _homeCubit.doIntent(
          SelectOrder(
            selectedOrder: order,
            driverId: driverId ?? "",
          ),
        );
      },
      onReject: () {
        setState(() {
          _rejectedOrderIds.add(order.id);
        });
      },
    );
  }
}
