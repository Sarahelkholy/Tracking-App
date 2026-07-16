import 'package:bloc_test/bloc_test.dart';
import 'package:flower_driver/config/base_state/base_state.dart';
import 'package:flower_driver/config/driver/manager/driver_cubit.dart';
import 'package:flower_driver/config/driver/manager/driver_state.dart';
import 'package:flower_driver/features/orders/domain/entities/orders_entity.dart';
import 'package:flower_driver/features/orders/presentation/mangers/home_cubit.dart';
import 'package:flower_driver/features/orders/presentation/mangers/home_event.dart';
import 'package:flower_driver/features/orders/presentation/mangers/home_state.dart';
import 'package:flower_driver/features/orders/presentation/pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHomeCubit extends MockCubit<HomeState> implements HomeCubit {}

class MockDriverCubit extends MockCubit<DriverState> implements DriverCubit {}

void main() {
  late MockHomeCubit mockHomeCubit;
  late MockDriverCubit mockDriverCubit;

  setUpAll(() {
    registerFallbackValue(GetPendingOrders());
  });

  setUp(() {
    mockHomeCubit = MockHomeCubit();
    mockDriverCubit = MockDriverCubit();

    // Default states
    when(() => mockDriverCubit.state).thenReturn(DriverState());
    when(() => mockHomeCubit.state).thenReturn(const HomeState());
    when(() => mockHomeCubit.doIntent(any())).thenAnswer((_) async {});
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<HomeCubit>.value(value: mockHomeCubit),
          BlocProvider<DriverCubit>.value(value: mockDriverCubit),
        ],
        child: const HomeScreen(),
      ),
    );
  }

  testWidgets('renders No pending orders found when state is empty',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    expect(find.text('No pending orders found.'), findsOneWidget);
  });

  testWidgets('renders loading indicator when state is loading',
      (WidgetTester tester) async {
    when(() => mockHomeCubit.state).thenReturn(
      const HomeState().copyWith(
        pendingOrdersState: const BaseState<OrdersEntity>(isLoading: true),
      ),
    );

    await tester.pumpWidget(createWidgetUnderTest());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
