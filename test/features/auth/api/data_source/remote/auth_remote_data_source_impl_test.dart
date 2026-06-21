import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/core/localization/l10n/app_localizations.dart';
import 'package:flower_driver/core/values/app_strings.dart';
import 'package:flower_driver/features/auth/api/auth_api_client.dart';
import 'package:flower_driver/features/auth/api/data_source/remote/auth_remote_data_source_impl.dart';
import 'package:flower_driver/features/auth/data/models/requests/login_request.dart';
import 'package:flower_driver/features/auth/data/models/responses/auth_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([AuthApiClient])
void main() {
  late AuthRemoteDataSourceImpl remoteDataSource;
  late MockAuthApiClient mockApiClient;

  setUpAll(() {
    AppStrings.current = lookupAppLocalizations(const Locale('en'));
  });

  setUp(() {
    mockApiClient = MockAuthApiClient();
    remoteDataSource = AuthRemoteDataSourceImpl(mockApiClient);
  });

  group("SignIn Tests", () {
    const tLoginRequest = LoginRequest(
      email: 'test@test.com',
      password: 'password123',
    );
    final tAuthResponse = AuthResponse(token: 'fake_token', message: 'Success');

    test("should return success when ApiClient returns AuthResponse", () async {
      when(mockApiClient.signIn(any)).thenAnswer((_) async => tAuthResponse);

      final result = await remoteDataSource.signIn(tLoginRequest);

      expect(result, isA<Success<AuthResponse>>());
      expect((result as Success<AuthResponse>).data.token, tAuthResponse.token);

      verify(mockApiClient.signIn(tLoginRequest)).called(1);
    });

    test("should return failure when ApiClient throws", () async {
      when(mockApiClient.signIn(any)).thenThrow(Exception());

      final result = await remoteDataSource.signIn(tLoginRequest);

      expect(result, isA<Failure<AuthResponse>>());
    });
  });
}
