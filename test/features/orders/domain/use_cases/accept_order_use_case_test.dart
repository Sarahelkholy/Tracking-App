import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/orders/domain/entities/enums/order_status_enum.dart';
import 'package:flower_driver/features/orders/domain/entities/order_entity.dart';
import 'package:flower_driver/features/orders/domain/entities/order_item_entity.dart';
import 'package:flower_driver/features/orders/domain/entities/order_product_entity.dart';
import 'package:flower_driver/features/orders/domain/entities/order_store_entity.dart';
import 'package:flower_driver/features/orders/domain/entities/order_user_entity.dart';
import 'package:flower_driver/features/orders/domain/entities/shipping_address_entity.dart';
import 'package:flower_driver/features/orders/domain/repositories/orders_repo.dart';
import 'package:flower_driver/features/orders/domain/use_cases/accept_order_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'accept_order_use_case_test.mocks.dart';

@GenerateMocks([OrdersRepo])
void main() {
  late AcceptOrderUseCase useCase;
  late MockOrdersRepo mockRepo;

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
    provideDummy<Result<bool>>(Success<bool>(data: true));
  });

  setUp(() {
    mockRepo = MockOrdersRepo();
    useCase = AcceptOrderUseCase(mockRepo);
  });

  group("Accept Order UseCase", () {
    test("success", () async {
      when(
        mockRepo.acceptOrder(any, any),
      ).thenAnswer((_) async => Success<bool>(data: true));

      final result = await useCase(tOrder, "driver_id");

      expect(result, isA<Success<bool>>());
      expect((result as Success<bool>).data, true);

      verify(mockRepo.acceptOrder(tOrder, "driver_id")).called(1);
    });

    test("failure", () async {
      when(
        mockRepo.acceptOrder(any, any),
      ).thenAnswer((_) async => Failure<bool>(errorMessage: errorMessage));

      final result = await useCase(tOrder, "driver_id");

      expect(result, isA<Failure<bool>>());
      expect((result as Failure<bool>).errorMessage, errorMessage);

      verify(mockRepo.acceptOrder(tOrder, "driver_id")).called(1);
    });
  });
}
