import 'package:bloc_test/bloc_test.dart';
import 'package:flower_driver/config/driver/domain/entities/driver_entity.dart';
import 'package:flower_driver/config/driver/manager/driver_cubit.dart';
import 'package:flower_driver/config/driver/manager/driver_events.dart';
import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/auth/data/models/responses/auth_response.dart';
import 'package:flower_driver/features/auth/domain/use_case/login_use_case.dart';
import 'package:flower_driver/features/auth/presentation/manager/login/login_cubit.dart';
import 'package:flower_driver/features/auth/presentation/manager/login/login_event.dart';
import 'package:flower_driver/features/auth/presentation/manager/login/login_state.dart';
import 'package:flower_driver/features/orders/domain/entities/order_entity.dart';
import 'package:flower_driver/features/orders/domain/use_cases/get_active_order_use_case.dart';
import 'package:flower_driver/config/driver/domain/use_cases/get_driver_data_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_cubit_test.mocks.dart';

import 'package:flower_driver/features/orders/domain/entities/order_item_entity.dart';
import 'package:flower_driver/features/orders/domain/entities/order_product_entity.dart';
import 'package:flower_driver/features/orders/domain/entities/order_store_entity.dart';
import 'package:flower_driver/features/orders/domain/entities/order_user_entity.dart';
import 'package:flower_driver/features/orders/domain/entities/shipping_address_entity.dart';
import 'package:flower_driver/features/orders/domain/entities/enums/order_status_enum.dart';

@GenerateMocks([
  LoginUseCase,
  GetDriverDataUseCase,
  GetActiveOrderUseCase,
  DriverCubit,
])
void main() {
  late LoginCubit cubit;
  late MockLoginUseCase mockLoginUseCase;
  late MockGetDriverDataUseCase mockGetDriverDataUseCase;
  late MockGetActiveOrderUseCase mockGetActiveOrderUseCase;
  late MockDriverCubit mockDriverCubit;

  final tAuthResponse = AuthResponse(message: "Success", token: "token");
  final tDriver = DriverEntity(id: "driver_id");

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

  setUpAll(() {
    provideDummy<Result<AuthResponse>>(Success(data: tAuthResponse));
    provideDummy<Result<DriverEntity>>(Success(data: tDriver));
    provideDummy<Result<OrderEntity>>(Success(data: tOrder));
  });

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockGetDriverDataUseCase = MockGetDriverDataUseCase();
    mockGetActiveOrderUseCase = MockGetActiveOrderUseCase();
    mockDriverCubit = MockDriverCubit();

    cubit = LoginCubit(
      mockLoginUseCase,
      mockGetDriverDataUseCase,
      mockGetActiveOrderUseCase,
      mockDriverCubit,
    );
  });

  group("LoginCubit Tests", () {
    test("initial state should be LoginInitial", () {
      expect(cubit.state, const LoginInitial());
    });

    blocTest<LoginCubit, LoginState>(
      "login success with active order",
      setUp: () {
        when(
          mockLoginUseCase.call(any, any),
        ).thenAnswer((_) async => Success(data: tAuthResponse));
        when(
          mockGetDriverDataUseCase.call(),
        ).thenAnswer((_) async => Success(data: tDriver));
        when(
          mockGetActiveOrderUseCase.call(any),
        ).thenAnswer((_) async => Success(data: tOrder));
      },
      build: () => cubit,
      act: (cubit) => cubit.doEvents(
        LoginSubmitEvent(
          email: "test@test.com",
          password: "password",
          rememberMe: true,
        ),
      ),
      expect: () => [
        const LoginLoading(rememberMe: true),
        LoginSuccess(
          authResponse: tAuthResponse,
          rememberMe: true,
          hasActiveOrder: true,
        ),
      ],
      verify: (_) {
        verify(
          mockDriverCubit.doEvent(
            argThat(
              isA<SetDriverDataEvent>().having(
                (e) => e.driver,
                'driver',
                tDriver,
              ),
            ),
          ),
        ).called(1);
      },
    );

    blocTest<LoginCubit, LoginState>(
      "login success without active order",
      setUp: () {
        when(
          mockLoginUseCase.call(any, any),
        ).thenAnswer((_) async => Success(data: tAuthResponse));
        when(
          mockGetDriverDataUseCase.call(),
        ).thenAnswer((_) async => Success(data: tDriver));
        when(
          mockGetActiveOrderUseCase.call(any),
        ).thenAnswer((_) async => Failure(errorMessage: "No active order"));
      },
      build: () => cubit,
      act: (cubit) => cubit.doEvents(
        LoginSubmitEvent(
          email: "test@test.com",
          password: "password",
          rememberMe: false,
        ),
      ),
      expect: () => [
        const LoginLoading(rememberMe: false),
        LoginSuccess(
          authResponse: tAuthResponse,
          rememberMe: false,
          hasActiveOrder: false,
        ),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      "login failure on first step",
      setUp: () {
        when(
          mockLoginUseCase.call(any, any),
        ).thenAnswer((_) async => Failure(errorMessage: "Login failed"));
      },
      build: () => cubit,
      act: (cubit) => cubit.doEvents(
        LoginSubmitEvent(
          email: "test@test.com",
          password: "password",
          rememberMe: false,
        ),
      ),
      expect: () => [
        const LoginLoading(rememberMe: false),
        const LoginFailure(errorMessage: "Login failed", rememberMe: false),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      "login failure on get driver data",
      setUp: () {
        when(
          mockLoginUseCase.call(any, any),
        ).thenAnswer((_) async => Success(data: tAuthResponse));
        when(
          mockGetDriverDataUseCase.call(),
        ).thenAnswer((_) async => Failure(errorMessage: "User data failed"));
      },
      build: () => cubit,
      act: (cubit) => cubit.doEvents(
        LoginSubmitEvent(
          email: "test@test.com",
          password: "password",
          rememberMe: false,
        ),
      ),
      expect: () => [
        const LoginLoading(rememberMe: false),
        const LoginFailure(errorMessage: "User data failed", rememberMe: false),
      ],
    );
    group('LoginRememberMeChangedEvent', () {
      blocTest<LoginCubit, LoginState>(
        'emits state with updated rememberMe when LoginRememberMeChangedEvent is added',
        build: () => cubit,
        act: (cubit) =>
            cubit.doEvents(LoginRememberMeChangedEvent(rememberMe: true)),
        expect: () => [const LoginInitial(rememberMe: true)],
      );
    });
  });
}

// Helper to mock objects without full instantiation if not needed for props
T mock<T>(T value) => value;
