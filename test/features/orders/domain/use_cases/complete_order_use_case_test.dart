import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/orders/domain/repositories/orders_repo.dart';
import 'package:flower_driver/features/orders/domain/use_cases/complete_order_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockOrdersRepo extends Mock implements OrdersRepo {}

void main() {
  late CompleteOrderUseCase useCase;
  late MockOrdersRepo mockRepo;

  setUp(() {
    mockRepo = MockOrdersRepo();
    useCase = CompleteOrderUseCase(mockRepo);
  });

  const tOrderId = 'order_123';

  test('should call completeOrder on repository', () async {
    when(mockRepo.completeOrder(any))
        .thenAnswer((_) async => Success(data: null));

    final result = await useCase(tOrderId);

    expect(result, isA<Success<void>>());
    verify(mockRepo.completeOrder(tOrderId)).called(1);
    verifyNoMoreInteractions(mockRepo);
  });

  test('should return failure from repository', () async {
    when(mockRepo.completeOrder(any))
        .thenAnswer((_) async => Failure(errorMessage: 'Error'));

    final result = await useCase(tOrderId);

    expect(result, isA<Failure<void>>());
    verify(mockRepo.completeOrder(tOrderId)).called(1);
    verifyNoMoreInteractions(mockRepo);
  });
}
