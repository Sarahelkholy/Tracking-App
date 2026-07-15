import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/orders/domain/repositories/orders_repo.dart';
import 'package:flower_driver/features/orders/domain/use_cases/update_driver_location_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockOrdersRepo extends Mock implements OrdersRepo {}

void main() {
  late UpdateDriverLocationUseCase useCase;
  late MockOrdersRepo mockRepo;

  setUp(() {
    mockRepo = MockOrdersRepo();
    useCase = UpdateDriverLocationUseCase(mockRepo);
  });

  const tOrderId = 'order_123';
  const tLat = 30.0;
  const tLong = 31.0;

  test('should call updateDriverLocation on repository', () async {
    when(mockRepo.updateDriverLocation(any, any, any))
        .thenAnswer((_) async => Success(data: null));

    final result = await useCase(tOrderId, tLat, tLong);

    expect(result, isA<Success<void>>());
    verify(mockRepo.updateDriverLocation(tOrderId, tLat, tLong)).called(1);
    verifyNoMoreInteractions(mockRepo);
  });

  test('should return failure from repository', () async {
    when(mockRepo.updateDriverLocation(any, any, any))
        .thenAnswer((_) async => Failure(errorMessage: 'Error'));

    final result = await useCase(tOrderId, tLat, tLong);

    expect(result, isA<Failure<void>>());
    verify(mockRepo.updateDriverLocation(tOrderId, tLat, tLong)).called(1);
    verifyNoMoreInteractions(mockRepo);
  });
}
