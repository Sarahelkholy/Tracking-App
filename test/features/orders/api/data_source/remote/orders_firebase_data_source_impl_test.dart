import 'package:flower_driver/config/data_base/data_base_service.dart';
import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/config/firebase/fcm_notification_service.dart';
import 'package:flower_driver/core/localization/l10n/app_localizations.dart';
import 'package:flower_driver/core/values/app_strings.dart';
import 'package:flower_driver/features/orders/api/data_source/remote/orders_firebase_data_source_impl.dart';
import 'package:flower_driver/features/orders/data/models/responses/active_order_firestore_response.dart';
import 'package:flower_driver/features/orders/data/models/responses/user_firestore_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'orders_firebase_data_source_impl_test.mocks.dart';

@GenerateMocks([DatabaseService, FcmNotificationService])
void main() {
  late OrdersFirebaseDataSourceImpl dataSource;
  late MockDatabaseService mockDatabaseService;
  late MockFcmNotificationService mockFcmNotificationService;

  setUpAll(() {
    AppStrings.current = lookupAppLocalizations(const Locale('en'));
  });

  setUp(() {
    mockDatabaseService = MockDatabaseService();
    mockFcmNotificationService = MockFcmNotificationService();
    dataSource = OrdersFirebaseDataSourceImpl(
      mockDatabaseService,
      mockFcmNotificationService,
    );
  });

  group("Get Active Order Tests", () {
    test("should return success when order exists", () async {
      final response = ActiveOrderFirestoreResponse(id: "order_123");

      when(
        mockDatabaseService.getCollection<ActiveOrderFirestoreResponse>(
          path: anyNamed('path'),
          queryParams: anyNamed('queryParams'),
          limit: anyNamed('limit'),
          fromFirestore: anyNamed('fromFirestore'),
        ),
      ).thenAnswer((_) async => [response]);

      final result = await dataSource.getActiveOrder("driver_123");

      expect(result, isA<Success<ActiveOrderFirestoreResponse>>());
      expect(
        (result as Success<ActiveOrderFirestoreResponse>).data.id,
        "order_123",
      );
    });

    test("should return failure when no active order found", () async {
      when(
        mockDatabaseService.getCollection<ActiveOrderFirestoreResponse>(
          path: anyNamed('path'),
          queryParams: anyNamed('queryParams'),
          limit: anyNamed('limit'),
          fromFirestore: anyNamed('fromFirestore'),
        ),
      ).thenAnswer((_) async => []);

      final result = await dataSource.getActiveOrder("driver_123");

      expect(result, isA<Failure<ActiveOrderFirestoreResponse>>());
      expect(
        (result as Failure).errorMessage,
        AppStrings.current.unexpectedErrorMessage,
      );
    });
  });

  group("Update Order Status Tests", () {
    test("should return success", () async {
      when(
        mockDatabaseService.updateData(
          path: anyNamed('path'),
          data: anyNamed('data'),
        ),
      ).thenAnswer((_) async => Future.value());

      final result = await dataSource.updateOrderStatus("order_123", {
        'status': 'picked',
      });

      expect(result, isA<Success<void>>());
      verify(
        mockDatabaseService.updateData(
          path: anyNamed('path'),
          data: anyNamed('data'),
        ),
      ).called(1);
    });
  });

  group("Save Active Order Tests", () {
    test("should return success", () async {
      final data = ActiveOrderFirestoreResponse(id: "order_123");
      when(
        mockDatabaseService.setData<ActiveOrderFirestoreResponse>(
          path: anyNamed('path'),
          data: anyNamed('data'),
          toFirestore: anyNamed('toFirestore'),
        ),
      ).thenAnswer((_) async => Future.value());

      final result = await dataSource.saveActiveOrder("order_123", data);

      expect(result, isA<Success<void>>());
    });
  });

  group("User Info Tests", () {
    test("getUserInfo should return success", () async {
      final user = UserFirestoreModel(fcmToken: "token", language: "en");
      when(
        mockDatabaseService.getDocument<UserFirestoreModel>(
          path: anyNamed('path'),
          fromFirestore: anyNamed('fromFirestore'),
        ),
      ).thenAnswer((_) async => user);

      final result = await dataSource.getUserInfo("user_123");

      expect(result, isA<Success<UserFirestoreModel?>>());
      expect((result as Success<UserFirestoreModel?>).data?.fcmToken, "token");
    });
  });

  group("Notification Tests", () {
    test("sendPushNotification should return success", () async {
      when(
        mockFcmNotificationService.sendNotification(
          fcmToken: anyNamed('fcmToken'),
          title: anyNamed('title'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => Future.value());

      final result = await dataSource.sendPushNotification(
        fcmToken: "token",
        title: "title",
        body: "body",
      );

      expect(result, isA<Success<void>>());
    });
  });
}
