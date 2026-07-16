import 'package:flower_driver/features/orders/presentation/mangers/orders_cubit.dart';
import 'package:flower_driver/features/orders/presentation/mangers/orders_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/order_card.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late final ScrollController _scrollController;
  late final OrdersCubit _ordersCubit;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _ordersCubit = context.read<OrdersCubit>();
    _ordersCubit.getOrders();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_ordersCubit.state.ordersState.isLoading) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    const threshold = 200.0;

    if (maxScroll - currentScroll <= threshold) {
      _ordersCubit.getOrders();
    }
  }

  Future<void> _handleRefresh() async {
    await _ordersCubit.getOrders(isRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          final orders = state.ordersState.data?.orders ?? [];

          if (state.ordersState.isLoading && orders.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (orders.isEmpty && !state.ordersState.isLoading) {
            return RefreshIndicator(
              onRefresh: _handleRefresh,
              child: ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Center(
                      child: Text(state.ordersState.errorMessage ?? "No orders found."),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _handleRefresh,
            child: ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: orders.length + (state.ordersState.isLoading ? 1 : 0),
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                if (index == orders.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                final order = orders[index];
                return OrderCard(
                  storeName: order.store.name,
                  storeAddress: order.shippingAddress.address,
                  storeImage: order.store.image,
                  userName: order.user.firstName,
                  userAddress: order.shippingAddress.address, // Assuming same for now or handle appropriately
                  userImage: order.user.photo,
                  price: "\$${order.totalPrice}",
                  status: order.orderStatus,
                  onAccept: () {}, // Not needed for history/all orders
                  onReject: () {}, // Not needed for history/all orders
                );
              },
            ),
          );
        },
      ),
    );
  }
}
