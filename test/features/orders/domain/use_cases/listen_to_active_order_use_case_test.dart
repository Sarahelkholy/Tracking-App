import 'package:flower_driver/features/orders/domain/entities/enums/order_status_enum.dart';
import 'package:flower_driver/features/orders/domain/entities/order_entity.dart';
import 'package:flower_driver/features/orders/domain/entities/order_item_entity.dart';
import 'package:flower_driver/features/orders/domain/entities/order_product_entity.dart';
import 'package:flower_driver/features/orders/domain/entities/order_store_entity.dart';
import 'package:flower_driver/features/orders/domain/entities/order_user_entity.dart';
import 'package:flower_driver/features/orders/domain/entities/shipping_address_entity.dart';
import 'package:flower_driver/features/orders/domain/repositories/orders_repo.dart';
import 'package:flower_driver/features/orders/domain/use_cases/listen_to_active_order_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'listen_to_active_order_use_case_test.mocks.dart';

@GenerateMocks([OrdersRepo])
void main() {
  late ListenToActiveOrderUseCase useCase;
  late MockOrdersRepo mockRepo;

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

  setUp(() {
    mockRepo = MockOrdersRepo();
    useCase = ListenToActiveOrderUseCase(mockRepo);
  });

  group("Listen To Active Order UseCase", () {
    test("should emit order from repo", () async {
      when(
        mockRepo.listenToActiveOrder(any),
      ).thenAnswer((_) => Stream.value(tOrder));

      final result = useCase("order_id");

      expect(result, emitsInOrder([tOrder]));

      verify(mockRepo.listenToActiveOrder("order_id")).called(1);
    });

    test("should emit null from repo", () async {
      when(
        mockRepo.listenToActiveOrder(any),
      ).thenAnswer((_) => Stream.value(null));

      final result = useCase("order_id");

      expect(result, emitsInOrder([null]));

      verify(mockRepo.listenToActiveOrder("order_id")).called(1);
    });
  });
}
