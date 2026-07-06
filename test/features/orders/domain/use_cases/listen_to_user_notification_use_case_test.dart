import 'package:flower_driver/features/orders/domain/entities/user_notification_entity.dart';
import 'package:flower_driver/features/orders/domain/repositories/orders_repo.dart';
import 'package:flower_driver/features/orders/domain/use_cases/listen_to_user_notification_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'listen_to_user_notification_use_case_test.mocks.dart';

@GenerateMocks([OrdersRepo])
void main() {
  late ListenToUserNotificationUseCase useCase;
  late MockOrdersRepo mockRepo;

  const tUserNotification = UserNotificationEntity(
    fcmToken: 'token',
    language: 'en',
  );

  setUp(() {
    mockRepo = MockOrdersRepo();
    useCase = ListenToUserNotificationUseCase(mockRepo);
  });

  group("Listen To User Notification UseCase", () {
    test("should emit notification from repo", () async {
      when(
        mockRepo.watchUserNotificationInfo(any),
      ).thenAnswer((_) => Stream.value(tUserNotification));

      final result = useCase("user_id");

      expect(result, emitsInOrder([tUserNotification]));

      verify(mockRepo.watchUserNotificationInfo("user_id")).called(1);
    });

    test("should emit null from repo", () async {
      when(
        mockRepo.watchUserNotificationInfo(any),
      ).thenAnswer((_) => Stream.value(null));

      final result = useCase("user_id");

      expect(result, emitsInOrder([null]));

      verify(mockRepo.watchUserNotificationInfo("user_id")).called(1);
    });
  });
}
