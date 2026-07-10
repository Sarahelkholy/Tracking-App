import 'package:bloc_test/bloc_test.dart';
import 'package:flower_driver/config/base_state/base_state.dart';
import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/orders/domain/entities/enums/order_status_enum.dart';
import 'package:flower_driver/features/orders/domain/entities/order_entity.dart';
import 'package:flower_driver/features/orders/domain/entities/order_item_entity.dart';
import 'package:flower_driver/features/orders/domain/entities/order_product_entity.dart';
import 'package:flower_driver/features/orders/domain/entities/order_store_entity.dart';
import 'package:flower_driver/features/orders/domain/entities/order_user_entity.dart';
import 'package:flower_driver/features/orders/domain/entities/shipping_address_entity.dart';
import 'package:flower_driver/features/orders/domain/entities/user_notification_entity.dart';
import 'package:flower_driver/features/orders/domain/use_cases/get_active_order_use_case.dart';
import 'package:flower_driver/features/orders/domain/use_cases/listen_to_active_order_use_case.dart';
import 'package:flower_driver/features/orders/domain/use_cases/listen_to_user_notification_use_case.dart';
import 'package:flower_driver/features/orders/domain/use_cases/update_order_status_use_case.dart';
import 'package:flower_driver/features/orders/presentation/manager/active_order_cubit/active_order_cubit.dart';
import 'package:flower_driver/features/orders/presentation/manager/active_order_cubit/active_order_event.dart';
import 'package:flower_driver/features/orders/presentation/manager/active_order_cubit/active_order_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'active_order_cubit_test.mocks.dart';

@GenerateMocks([
  GetActiveOrderUseCase,
  ListenToActiveOrderUseCase,
  UpdateOrderStatusUseCase,
  ListenToUserNotificationUseCase,
])
void main() {
  late ActiveOrderCubit cubit;

  late MockGetActiveOrderUseCase mockGetActiveOrderUseCase;
  late MockListenToActiveOrderUseCase mockListenToActiveOrderUseCase;
  late MockUpdateOrderStatusUseCase mockUpdateOrderStatusUseCase;
  late MockListenToUserNotificationUseCase mockListenToUserNotificationUseCase;

  late String errorMessage;

  final tOrder = OrderEntity(
    id: 'order_id',
    user: OrderUserEntity(
      id: 'user_id',
      firstName: 'User',
      lastName: 'One',
      email: 'user@test.com',
      gender: 'male',
      phone: '0111111111',
      photo: 'user_photo',
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
          imgCover: 'img_cover',
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
      image: 'store_image',
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
    orderStatus: OrderStatusEnum.accepted,
  );

  const tUserNotification = UserNotificationEntity(
    fcmToken: 'fcm_token',
    language: 'en',
  );

  setUpAll(() {
    errorMessage = "Something went wrong";

    provideDummy<Result<OrderEntity>>(Success<OrderEntity>(data: tOrder));
    provideDummy<Result<void>>(Success<void>(data: null));
  });

  setUp(() {
    mockGetActiveOrderUseCase = MockGetActiveOrderUseCase();
    mockListenToActiveOrderUseCase = MockListenToActiveOrderUseCase();
    mockUpdateOrderStatusUseCase = MockUpdateOrderStatusUseCase();
    mockListenToUserNotificationUseCase = MockListenToUserNotificationUseCase();

    cubit = ActiveOrderCubit(
      mockGetActiveOrderUseCase,
      mockListenToActiveOrderUseCase,
      mockUpdateOrderStatusUseCase,
      mockListenToUserNotificationUseCase,
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  group("Active Order Cubit Test Group", () {
    test("initial state should be ActiveOrderState", () {
      expect(cubit.state, const ActiveOrderState());
    });

    blocTest<ActiveOrderCubit, ActiveOrderState>(
      "get active order success",
      setUp: () {
        when(
          mockGetActiveOrderUseCase.call(any),
        ).thenAnswer((_) async => Success<OrderEntity>(data: tOrder));
        when(
          mockListenToActiveOrderUseCase.call(any),
        ).thenAnswer((_) => const Stream.empty());
        when(
          mockListenToUserNotificationUseCase.call(any),
        ).thenAnswer((_) => const Stream.empty());
      },
      build: () => cubit,
      act: (cubit) {
        cubit.doEvents(GetActiveOrderEvent(driverId: "driver_id"));
      },
      expect: () => [
        const ActiveOrderState().copyWith(
          getActiveOrderStateParam: const BaseState(isLoading: true),
        ),
        const ActiveOrderState().copyWith(
          getActiveOrderStateParam: BaseState(isSuccess: true, data: tOrder),
          orderParam: tOrder,
        ),
      ],
      verify: (_) {
        verify(mockGetActiveOrderUseCase.call("driver_id")).called(1);
        verify(mockListenToActiveOrderUseCase.call(tOrder.id)).called(1);
        verify(
          mockListenToUserNotificationUseCase.call(tOrder.user.id),
        ).called(1);
      },
    );

    blocTest<ActiveOrderCubit, ActiveOrderState>(
      "get active order failure",
      setUp: () {
        when(mockGetActiveOrderUseCase.call(any)).thenAnswer(
          (_) async => Failure<OrderEntity>(errorMessage: errorMessage),
        );
      },
      build: () => cubit,
      act: (cubit) {
        cubit.doEvents(GetActiveOrderEvent(driverId: "driver_id"));
      },
      expect: () => [
        const ActiveOrderState().copyWith(
          getActiveOrderStateParam: const BaseState(isLoading: true),
        ),
        const ActiveOrderState().copyWith(
          getActiveOrderStateParam: BaseState(errorMessage: errorMessage),
        ),
      ],
    );

    blocTest<ActiveOrderCubit, ActiveOrderState>(
      "update order status success",
      setUp: () {
        when(
          mockUpdateOrderStatusUseCase.call(any),
        ).thenAnswer((_) async => Success<void>(data: null));
      },
      build: () => cubit,
      act: (cubit) {
        cubit.doEvents(
          UpdateOrderStatusEvent(order: tOrder, status: OrderStatusEnum.picked),
        );
      },
      expect: () => [
        const ActiveOrderState().copyWith(
          updateOrderStatusStateParam: const BaseState(isLoading: true),
        ),
        const ActiveOrderState().copyWith(
          updateOrderStatusStateParam: const BaseState(isSuccess: true),
        ),
      ],
      verify: (_) {
        verify(
          mockUpdateOrderStatusUseCase.call(
            argThat(
              isA<UpdateOrderStatusParams>()
                  .having((p) => p.order, 'order', tOrder)
                  .having((p) => p.status, 'status', OrderStatusEnum.picked),
            ),
          ),
        ).called(1);
      },
    );

    blocTest<ActiveOrderCubit, ActiveOrderState>(
      "update order status failure",
      setUp: () {
        when(
          mockUpdateOrderStatusUseCase.call(any),
        ).thenAnswer((_) async => Failure<void>(errorMessage: errorMessage));
      },
      build: () => cubit,
      act: (cubit) {
        cubit.doEvents(
          UpdateOrderStatusEvent(order: tOrder, status: OrderStatusEnum.picked),
        );
      },
      expect: () => [
        const ActiveOrderState().copyWith(
          updateOrderStatusStateParam: const BaseState(isLoading: true),
        ),
        const ActiveOrderState().copyWith(
          updateOrderStatusStateParam: BaseState(errorMessage: errorMessage),
        ),
      ],
    );

    blocTest<ActiveOrderCubit, ActiveOrderState>(
      "order updated event updates state with new order",
      setUp: () {
        when(
          mockListenToUserNotificationUseCase.call(any),
        ).thenAnswer((_) => const Stream.empty());
      },
      build: () => cubit,
      act: (cubit) {
        cubit.doEvents(OrderUpdatedEvent(tOrder));
      },
      expect: () => [const ActiveOrderState().copyWith(orderParam: tOrder)],
    );

    blocTest<ActiveOrderCubit, ActiveOrderState>(
      "user notification update from stream",
      setUp: () {
        when(
          mockListenToUserNotificationUseCase.call(any),
        ).thenAnswer((_) => Stream.value(tUserNotification));
        when(
          mockGetActiveOrderUseCase.call(any),
        ).thenAnswer((_) async => Success<OrderEntity>(data: tOrder));
        when(
          mockListenToActiveOrderUseCase.call(any),
        ).thenAnswer((_) => const Stream.empty());
      },
      build: () => cubit,
      act: (cubit) {
        cubit.doEvents(GetActiveOrderEvent(driverId: "driver_id"));
      },
      skip: 2,
      expect: () => [
        const ActiveOrderState().copyWith(
          getActiveOrderStateParam: BaseState(isSuccess: true, data: tOrder),
          orderParam: tOrder,
          userNotificationParam: tUserNotification,
        ),
      ],
    );
  });
}
