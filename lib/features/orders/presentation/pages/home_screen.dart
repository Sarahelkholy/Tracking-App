import 'package:flower_driver/features/orders/presentation/mangers/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../mangers/home_cubit.dart';
import '../mangers/home_event.dart';


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
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (BuildContext context, HomeState state) {
          if (state.pendingOrdersState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return const Center(child: Text('Home Screen'));
        },
      ),
    );
  }
}
