import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/orders/domain/entities/orders_entity.dart';
import 'package:flower_driver/features/orders/domain/entities/orders_metadata_entity.dart';
import 'package:flower_driver/features/orders/domain/repositories/orders_repo.dart';
import 'package:flower_driver/features/orders/domain/use_cases/get_all_pending_orders_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_all_pending_orders_use_case_test.mocks.dart';

@GenerateMocks([OrdersRepo])
void main() {
  late GetAllPendingOrdersUseCase useCase;
  late MockOrdersRepo mockRepo;

  late String errorMessage;

  const tOrdersEntity = OrdersEntity(
    message: "Success",
    metadata: OrdersMetadataEntity(
      currentPage: 1,
      totalPages: 1,
      totalItems: 0,
      limit: 10,
    ),
    orders: [],
  );

  setUpAll(() {
    errorMessage = "Something went wrong";

    provideDummy<Result<OrdersEntity>>(
      Success<OrdersEntity>(data: tOrdersEntity),
    );
  });

  setUp(() {
    mockRepo = MockOrdersRepo();
    useCase = GetAllPendingOrdersUseCase(mockRepo);
  });

  group("Get All Pending Orders UseCase", () {
    test("success", () async {
      when(
        mockRepo.getAllPendingOrders(),
      ).thenAnswer((_) async => Success<OrdersEntity>(data: tOrdersEntity));

      final result = await useCase();

      expect(result, isA<Success<OrdersEntity>>());
      expect((result as Success<OrdersEntity>).data, tOrdersEntity);

      verify(mockRepo.getAllPendingOrders()).called(1);
    });

    test("failure", () async {
      when(mockRepo.getAllPendingOrders()).thenAnswer(
        (_) async => Failure<OrdersEntity>(errorMessage: errorMessage),
      );

      final result = await useCase();

      expect(result, isA<Failure<OrdersEntity>>());
      expect((result as Failure<OrdersEntity>).errorMessage, errorMessage);

      verify(mockRepo.getAllPendingOrders()).called(1);
    });
  });
}
