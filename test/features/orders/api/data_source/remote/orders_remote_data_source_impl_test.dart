import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/core/localization/l10n/app_localizations.dart';
import 'package:flower_driver/core/values/app_strings.dart';
import 'package:flower_driver/features/orders/api/orders_api_client.dart';
import 'package:flower_driver/features/orders/api/data_source/remote/orders_remote_data_source_impl.dart';
import 'package:flower_driver/features/orders/data/models/responses/orders_response/orders_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'orders_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([OrdersApiClient])
void main() {
  late OrdersRemoteDataSourceImpl remoteDataSource;
  late MockOrdersApiClient mockApiClient;

  setUpAll(() {
    AppStrings.current = lookupAppLocalizations(const Locale('en'));
  });

  setUp(() {
    mockApiClient = MockOrdersApiClient();
    remoteDataSource = OrdersRemoteDataSourceImpl(mockApiClient);
  });

  group("Get All Pending Orders Tests", () {
    test("should return success", () async {
      final response = OrdersResponse(
        message: "Success",
        metadata: null,
        orders: [],
      );

      when(
        mockApiClient.getAllPendingOrders(),
      ).thenAnswer((_) async => response);

      final result = await remoteDataSource.getAllPendingOrders();

      expect(result, isA<Success<OrdersResponse>>());
      expect(
        (result as Success<OrdersResponse>).data.message,
        response.message,
      );

      verify(mockApiClient.getAllPendingOrders()).called(1);
    });

    test("should return failure", () async {
      when(mockApiClient.getAllPendingOrders()).thenThrow(Exception());

      final result = await remoteDataSource.getAllPendingOrders();

      expect(result, isA<Failure<OrdersResponse>>());

      verify(mockApiClient.getAllPendingOrders()).called(1);
    });
  });
}
