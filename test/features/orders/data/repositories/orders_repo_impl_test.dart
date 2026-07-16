import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/core/helpers/notification_localizer.dart';
import 'package:flower_driver/features/orders/data/data_source/remote/orders_firebase_data_source.dart';
import 'package:flower_driver/features/orders/data/data_source/remote/orders_remote_data_source.dart';
import 'package:flower_driver/features/orders/data/models/responses/active_order_firestore_response.dart';
import 'package:flower_driver/features/orders/data/models/responses/orders_response/orders_response.dart';
import 'package:flower_driver/features/orders/data/models/responses/user_firestore_model.dart';
import 'package:flower_driver/features/orders/data/repositories/orders_repo_impl.dart';
import 'package:flower_driver/features/orders/domain/entities/enums/order_status_enum.dart';
import 'package:flower_driver/features/orders/domain/entities/order_entity.dart';
import 'package:flower_driver/features/orders/domain/entities/order_item_entity.dart';
import 'package:flower_driver/features/orders/domain/entities/order_product_entity.dart';
import 'package:flower_driver/features/orders/domain/entities/order_store_entity.dart';
import 'package:flower_driver/features/orders/domain/entities/order_user_entity.dart';
import 'package:flower_driver/features/orders/domain/entities/shipping_address_entity.dart';
import 'package:flower_driver/features/orders/domain/entities/orders_entity.dart';
import 'package:flower_driver/features/orders/domain/use_cases/update_order_status_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'orders_repo_impl_test.mocks.dart';

@GenerateMocks([
  OrdersRemoteDataSource,
  OrdersFirebaseDataSource,
  NotificationLocalizer,
])
void main() {
  late OrdersRepoImpl repo;
  late MockOrdersRemoteDataSource mockRemoteDataSource;
  late MockOrdersFirebaseDataSource mockFirebaseDataSource;
  late MockNotificationLocalizer mockNotificationLocalizer;

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

  setUpAll(() {
    errorMessage = "Something went wrong";
    provideDummy<Result<OrdersResponse>>(Success(data: OrdersResponse()));
    provideDummy<Result<ActiveOrderFirestoreResponse>>(
      Success(data: ActiveOrderFirestoreResponse()),
    );
    provideDummy<Result<void>>(Success(data: null));
    provideDummy<Result<UserFirestoreModel?>>(Success(data: null));
  });

  setUp(() {
    mockRemoteDataSource = MockOrdersRemoteDataSource();
    mockFirebaseDataSource = MockOrdersFirebaseDataSource();
    mockNotificationLocalizer = MockNotificationLocalizer();
    repo = OrdersRepoImpl(
      mockRemoteDataSource,
      mockFirebaseDataSource,
      mockNotificationLocalizer,
    );
  });

  group("Get All Pending Orders Tests", () {
    test("success", () async {
      when(mockRemoteDataSource.getAllPendingOrders(any, any)).thenAnswer(
        (_) async => Success(
          data: OrdersResponse(message: "Success", orders: []),
        ),
      );

      final result = await repo.getAllPendingOrders(1, 10);

      expect(result, isA<Success<OrdersEntity>>());
      expect((result as Success).data.message, "Success");
      verify(mockRemoteDataSource.getAllPendingOrders(any, any)).called(1);
    });

    test("failure", () async {
      when(
        mockRemoteDataSource.getAllPendingOrders(any, any),
      ).thenAnswer((_) async => Failure(errorMessage: errorMessage));

      final result = await repo.getAllPendingOrders(1, 10);

      expect(result, isA<Failure<OrdersEntity>>());
      expect((result as Failure).errorMessage, errorMessage);
    });
  });

  group("Get Active Order Tests", () {
    test("success", () async {
      when(mockFirebaseDataSource.getActiveOrder(any)).thenAnswer(
        (_) async =>
            Success(data: ActiveOrderFirestoreResponse(id: "order_123")),
      );

      final result = repo.getActiveOrder("driver_123");

      expect(result, isA<Success<OrderEntity>>());
      verify(mockFirebaseDataSource.getActiveOrder("driver_123")).called(1);
    });
  });

  group("Accept Order Tests", () {
    test("success", () async {
      when(
        mockFirebaseDataSource.saveActiveOrder(any, any),
      ).thenAnswer((_) async => Success(data: null));
      when(mockFirebaseDataSource.getUserInfo(any)).thenAnswer(
        (_) async => Success(
          data: UserFirestoreModel(fcmToken: "token", language: "en"),
        ),
      );

      when(
        mockNotificationLocalizer.getOrderAcceptedTitle(any),
      ).thenReturn("Title");
      when(
        mockNotificationLocalizer.getOrderAcceptedBody(any, any),
      ).thenReturn("Body");

      when(
        mockFirebaseDataSource.sendPushNotification(
          fcmToken: anyNamed('fcmToken'),
          title: anyNamed('title'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => Success(data: null));

      when(
        mockFirebaseDataSource.saveNotification(any, any),
      ).thenAnswer((_) async => Success(data: null));

      final result = await repo.acceptOrder(tOrder, "driver_123");

      expect(result, isA<Success<bool>>());
      expect((result as Success).data, true);
    });
  });

  group("Update Driver Location Tests", () {
    test("success", () async {
      when(
        mockFirebaseDataSource.updateOrderStatus(any, any),
      ).thenAnswer((_) async => Success(data: null));

      final result = await repo.updateDriverLocation("order_id", 30.0, 31.0);

      expect(result, isA<Success<void>>());
      verify(mockFirebaseDataSource.updateOrderStatus("order_id", any)).called(1);
    });
  });

  group("Complete Order Tests", () {
    test("success", () async {
      when(
        mockRemoteDataSource.updateOrderState(any, any),
      ).thenAnswer((_) async => Success(data: null));

      final result = await repo.completeOrder("order_id");

      expect(result, isA<Success<void>>());
      verify(mockRemoteDataSource.updateOrderState("order_id", any)).called(1);
    });
  });

  group("Update Order Status Tests", () {
    test("success", () async {
      final params = UpdateOrderStatusParams(
        order: tOrder,
        status: OrderStatusEnum.picked,
      );
      when(
        mockFirebaseDataSource.updateOrderStatus(any, any),
      ).thenAnswer((_) async => Success(data: null));

      final result = await repo.updateOrderStatus(params);

      expect(result, isA<Success<void>>());
      verify(
        mockFirebaseDataSource.updateOrderStatus(tOrder.id, any),
      ).called(1);
    });
  });
}
