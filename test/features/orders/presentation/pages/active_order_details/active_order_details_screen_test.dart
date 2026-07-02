import 'dart:async';

import 'package:flower_driver/config/base_cubit/base_event.dart';
import 'package:flower_driver/config/base_state/base_state.dart';
import 'package:flower_driver/config/driver/domain/entities/driver_entity.dart';
import 'package:flower_driver/config/driver/manager/driver_cubit.dart';
import 'package:flower_driver/config/driver/manager/driver_state.dart';
import 'package:flower_driver/core/localization/l10n/app_localizations.dart';
import 'package:flower_driver/core/values/app_strings.dart';
import 'package:flower_driver/core/values/keys_strings.dart';
import 'package:flower_driver/features/orders/domain/entities/enums/order_status_enum.dart';
import 'package:flower_driver/features/orders/domain/entities/order_entity.dart';
import 'package:flower_driver/features/orders/domain/entities/order_item_entity.dart';
import 'package:flower_driver/features/orders/domain/entities/order_product_entity.dart';
import 'package:flower_driver/features/orders/domain/entities/order_store_entity.dart';
import 'package:flower_driver/features/orders/domain/entities/order_user_entity.dart';
import 'package:flower_driver/features/orders/domain/entities/shipping_address_entity.dart';
import 'package:flower_driver/features/orders/presentation/manager/active_order_cubit/active_order_cubit.dart';
import 'package:flower_driver/features/orders/presentation/manager/active_order_cubit/active_order_event.dart';
import 'package:flower_driver/features/orders/presentation/manager/active_order_cubit/active_order_state.dart';
import 'package:flower_driver/features/orders/presentation/pages/active_order_details/active_order_details_screen.dart';
import 'package:flower_driver/features/orders/presentation/widgets/active_order_details/order_details_item.dart';
import 'package:flower_driver/features/orders/presentation/widgets/active_order_details/order_status_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'active_order_details_screen_test.mocks.dart';

@GenerateMocks([ActiveOrderCubit, DriverCubit])
void main() {
  late MockActiveOrderCubit mockActiveOrderCubit;
  late MockDriverCubit mockDriverCubit;
  late StreamController<BaseEvent> eventController;

  final tDriver = DriverEntity(
    id: 'driver_id',
    country: 'Egypt',
    firstName: 'John',
    lastName: 'Doe',
    vehicleType: 'Car',
    vehicleNumber: '123 ABC',
    vehicleLicense: '123456',
    nid: '1234567890',
    nidImg: 'nid_img',
    email: 'driver@test.com',
    gender: 'male',
    phone: '0123456789',
    photo: '',
    role: 'driver',
    createdAt: DateTime.now(),
  );

  OrderEntity getOrderWithStatus(OrderStatusEnum status) {
    return OrderEntity(
      id: 'order_id',
      user: OrderUserEntity(
        id: 'user_id',
        firstName: 'User',
        lastName: 'One',
        email: 'user@test.com',
        gender: 'male',
        phone: '0111111111',
        photo: '',
        passwordChangedAt: DateTime.now(),
        resetCodeVerified: true,
      ),
      orderItems: [
        OrderItemEntity(
          id: 'item_1',
          price: 100,
          quantity: 2,
          product: OrderProductEntity(
            id: 'prod_1',
            title: 'Flower 1',
            slug: 'flower-1',
            description: 'Beautiful flower',
            imgCover: '',
            images: const [],
            price: 100,
            priceAfterDiscount: 90,
            discount: 10,
            rateAvg: 4.5,
            rateCount: 10,
            sold: 5,
            quantity: 20,
            category: 'Category',
            occasion: 'Occasion',
            isSuperAdmin: false,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            v: 1,
          ),
        ),
      ],
      totalPrice: 200,
      paymentType: 'cash',
      isPaid: false,
      isDelivered: false,
      state: 'active',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      orderNumber: 'ORDER-123',
      v: 1,
      store: const OrderStoreEntity(
        name: 'Store Name',
        image: '',
        address: 'Store Address',
        phoneNumber: '0122222222',
        latLong: '30,31',
      ),
      shippingAddress: const ShippingAddressEntity(
        street: 'User Street',
        city: 'User City',
        phone: '0111111111',
        lat: '30',
        long: '31',
      ),
      paidAt: DateTime.now(),
      orderStatus: status,
    );
  }

  setUp(() {
    mockActiveOrderCubit = MockActiveOrderCubit();
    mockDriverCubit = MockDriverCubit();
    eventController = StreamController<BaseEvent>();

    when(mockDriverCubit.state).thenReturn(DriverState(driver: tDriver));
    when(mockDriverCubit.stream).thenAnswer((_) => const Stream.empty());

    when(mockActiveOrderCubit.state).thenReturn(
      ActiveOrderState(order: getOrderWithStatus(OrderStatusEnum.accepted)),
    );
    when(mockActiveOrderCubit.stream).thenAnswer((_) => const Stream.empty());
    when(
      mockActiveOrderCubit.eventStream,
    ).thenAnswer((_) => eventController.stream);
    when(mockActiveOrderCubit.doEvents(any)).thenReturn(null);
  });

  tearDown(() async {
    await eventController.close();
  });

  Future<void> pumpScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<ActiveOrderCubit>.value(value: mockActiveOrderCubit),
          BlocProvider<DriverCubit>.value(value: mockDriverCubit),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          builder: (context, child) {
            AppStrings.current = AppLocalizations.of(context)!;
            return child!;
          },
          home: const ActiveOrderDetailsScreen(),
        ),
      ),
    );
  }

  group('ActiveOrderDetailsScreen Initialization Tests', () {
    testWidgets('should call GetActiveOrderEvent with driver id on initState', (
      tester,
    ) async {
      await pumpScreen(tester);
      verify(
        mockActiveOrderCubit.doEvents(
          argThat(
            isA<GetActiveOrderEvent>().having(
              (e) => e.driverId,
              'driverId',
              'driver_id',
            ),
          ),
        ),
      ).called(1);
    });
  });

  group('ActiveOrderDetailsScreen Initial Rendering Tests', () {
    testWidgets('should render all basic components', (tester) async {
      await pumpScreen(tester);

      expect(
        find.byKey(const Key(KeysStrings.activeOrderAppBar)),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key(KeysStrings.activeOrderProgressBar)),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key(KeysStrings.activeOrderDetailsStatus)),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key(KeysStrings.activeOrderPickupAddress)),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key(KeysStrings.activeOrderUserAddress)),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key(KeysStrings.activeOrderItemsList)),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key(KeysStrings.activeOrderTotal)),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key(KeysStrings.activeOrderPaymentMethod)),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key(KeysStrings.activeOrderButton)),
        findsOneWidget,
      );
    });

    testWidgets('should display correct order data', (tester) async {
      await pumpScreen(tester);

      expect(find.text('ORDER-123'), findsOneWidget);
      expect(find.text('Store Name'), findsOneWidget);
      expect(find.text('User One'), findsOneWidget);
      expect(find.text('Flower 1'), findsOneWidget);
      expect(find.text('EGP 200'), findsOneWidget);
      expect(find.text('cash'), findsOneWidget);
    });
  });

  group('ActiveOrderDetailsScreen State Tests', () {
    testWidgets('should show loading indicator when fetching order', (
      tester,
    ) async {
      when(mockActiveOrderCubit.state).thenReturn(
        const ActiveOrderState(getActiveOrderState: BaseState(isLoading: true)),
      );

      await pumpScreen(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show empty state when order is null', (tester) async {
      when(
        mockActiveOrderCubit.state,
      ).thenReturn(const ActiveOrderState(order: null));

      await pumpScreen(tester);

      expect(find.text(AppStrings.current.noActiveOrderFound), findsOneWidget);
    });

    testWidgets('should show loading on button during status update', (
      tester,
    ) async {
      when(mockActiveOrderCubit.state).thenReturn(
        ActiveOrderState(
          order: getOrderWithStatus(OrderStatusEnum.accepted),
          updateOrderStatusState: const BaseState(isLoading: true),
        ),
      );

      await pumpScreen(tester);

      expect(
        find.descendant(
          of: find.byKey(const Key(KeysStrings.activeOrderButton)),
          matching: find.byType(CircularProgressIndicator),
        ),
        findsOneWidget,
      );
    });
  });

  group('ActiveOrderDetailsScreen Order Status Interaction Tests', () {
    testWidgets('should call update status to picked when status is accepted', (
      tester,
    ) async {
      final order = getOrderWithStatus(OrderStatusEnum.accepted);
      when(
        mockActiveOrderCubit.state,
      ).thenReturn(ActiveOrderState(order: order));

      await pumpScreen(tester);

      await tester.tap(find.byKey(const Key(KeysStrings.activeOrderButton)));
      await tester.pump();

      verify(
        mockActiveOrderCubit.doEvents(
          argThat(
            isA<UpdateOrderStatusEvent>().having(
              (e) => e.status,
              'status',
              OrderStatusEnum.picked.name,
            ),
          ),
        ),
      ).called(1);
    });

    testWidgets(
      'should call update status to outForDelivery when status is picked',
      (tester) async {
        final order = getOrderWithStatus(OrderStatusEnum.picked);
        when(
          mockActiveOrderCubit.state,
        ).thenReturn(ActiveOrderState(order: order));

        await pumpScreen(tester);

        await tester.tap(find.byKey(const Key(KeysStrings.activeOrderButton)));
        await tester.pump();

        verify(
          mockActiveOrderCubit.doEvents(
            argThat(
              isA<UpdateOrderStatusEvent>().having(
                (e) => e.status,
                'status',
                OrderStatusEnum.outForDelivery.name,
              ),
            ),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'should call update status to arrived when status is outForDelivery',
      (tester) async {
        final order = getOrderWithStatus(OrderStatusEnum.outForDelivery);
        when(
          mockActiveOrderCubit.state,
        ).thenReturn(ActiveOrderState(order: order));

        await pumpScreen(tester);

        await tester.tap(find.byKey(const Key(KeysStrings.activeOrderButton)));
        await tester.pump();

        verify(
          mockActiveOrderCubit.doEvents(
            argThat(
              isA<UpdateOrderStatusEvent>().having(
                (e) => e.status,
                'status',
                OrderStatusEnum.arrived.name,
              ),
            ),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'should call update status to delivered when status is arrived',
      (tester) async {
        final order = getOrderWithStatus(OrderStatusEnum.arrived);
        when(
          mockActiveOrderCubit.state,
        ).thenReturn(ActiveOrderState(order: order));

        await pumpScreen(tester);

        await tester.tap(find.byKey(const Key(KeysStrings.activeOrderButton)));
        await tester.pump();

        verify(
          mockActiveOrderCubit.doEvents(
            argThat(
              isA<UpdateOrderStatusEvent>()
                  .having(
                    (e) => e.status,
                    'status',
                    OrderStatusEnum.delivered.name,
                  )
                  .having((e) => e.isActive, 'isActive', false),
            ),
          ),
        ).called(1);
      },
    );

    testWidgets('button should be disabled when status is delivered', (
      tester,
    ) async {
      final order = getOrderWithStatus(OrderStatusEnum.delivered);
      when(
        mockActiveOrderCubit.state,
      ).thenReturn(ActiveOrderState(order: order));

      await pumpScreen(tester);

      final button = tester.widget<ElevatedButton>(
        find.descendant(
          of: find.byKey(const Key(KeysStrings.activeOrderButton)),
          matching: find.byType(ElevatedButton),
        ),
      );

      expect(button.enabled, isFalse);
    });
  });

  group('ActiveOrderDetailsScreen Content Verification Tests', () {
    testWidgets('should display correct button title when status is accepted', (
      tester,
    ) async {
      when(mockActiveOrderCubit.state).thenReturn(
        ActiveOrderState(order: getOrderWithStatus(OrderStatusEnum.accepted)),
      );
      await pumpScreen(tester);
      expect(
        find.text(AppStrings.current.arrivedAtPickupPoint),
        findsOneWidget,
      );
    });

    testWidgets('should display correct button title when status is picked', (
      tester,
    ) async {
      when(mockActiveOrderCubit.state).thenReturn(
        ActiveOrderState(order: getOrderWithStatus(OrderStatusEnum.picked)),
      );
      await pumpScreen(tester);
      expect(find.text(AppStrings.current.startDeliver), findsOneWidget);
    });

    testWidgets(
      'should display correct button title when status is outForDelivery',
      (tester) async {
        when(mockActiveOrderCubit.state).thenReturn(
          ActiveOrderState(
            order: getOrderWithStatus(OrderStatusEnum.outForDelivery),
          ),
        );
        await pumpScreen(tester);
        expect(find.text(AppStrings.current.arrivedToTheUser), findsOneWidget);
      },
    );

    testWidgets('should display correct button title when status is arrived', (
      tester,
    ) async {
      when(mockActiveOrderCubit.state).thenReturn(
        ActiveOrderState(order: getOrderWithStatus(OrderStatusEnum.arrived)),
      );
      await pumpScreen(tester);
      expect(find.text(AppStrings.current.deliveredToTheUser), findsOneWidget);
    });
  });

  group('ActiveOrderDetailsScreen List and Contacts Tests', () {
    testWidgets('should render multiple order items', (tester) async {
      final order = getOrderWithStatus(OrderStatusEnum.accepted);
      final items = [
        order.orderItems[0],
        OrderItemEntity(
          id: 'item_2',
          price: 50,
          quantity: 1,
          product: order.orderItems[0].product,
        ),
      ];
      final orderWithMoreItems = OrderEntity(
        id: order.id,
        user: order.user,
        orderItems: items,
        totalPrice: 250,
        paymentType: order.paymentType,
        isPaid: order.isPaid,
        isDelivered: order.isDelivered,
        state: order.state,
        createdAt: order.createdAt,
        updatedAt: order.updatedAt,
        orderNumber: order.orderNumber,
        v: order.v,
        store: order.store,
        shippingAddress: order.shippingAddress,
        paidAt: order.paidAt,
        orderStatus: order.orderStatus,
      );

      when(
        mockActiveOrderCubit.state,
      ).thenReturn(ActiveOrderState(order: orderWithMoreItems));

      await pumpScreen(tester);

      expect(find.byType(OrderDetailsItem), findsNWidgets(2));
      expect(find.text('EGP 250'), findsOneWidget);
    });

    testWidgets('should render contact cards with correct info', (
      tester,
    ) async {
      await pumpScreen(tester);

      expect(
        find.descendant(
          of: find.byKey(const Key(KeysStrings.activeOrderPickupAddress)),
          matching: find.text('Store Name'),
        ),
        findsOneWidget,
      );

      expect(
        find.descendant(
          of: find.byKey(const Key(KeysStrings.activeOrderUserAddress)),
          matching: find.text('User One'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('should show correct progress bar step for status accepted', (
      tester,
    ) async {
      when(mockActiveOrderCubit.state).thenReturn(
        ActiveOrderState(order: getOrderWithStatus(OrderStatusEnum.accepted)),
      );
      await pumpScreen(tester);

      final progressBar = tester.widget<OrderStatusProgressBar>(
        find.byKey(const Key(KeysStrings.activeOrderProgressBar)),
      );
      expect(progressBar.currentStep, 1);
    });

    testWidgets('should show correct progress bar step for status picked', (
      tester,
    ) async {
      when(mockActiveOrderCubit.state).thenReturn(
        ActiveOrderState(order: getOrderWithStatus(OrderStatusEnum.picked)),
      );
      await pumpScreen(tester);

      final progressBar = tester.widget<OrderStatusProgressBar>(
        find.byKey(const Key(KeysStrings.activeOrderProgressBar)),
      );
      expect(progressBar.currentStep, 2);
    });
  });
}
