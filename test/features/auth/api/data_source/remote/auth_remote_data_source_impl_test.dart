import 'dart:io';
import 'package:flower_driver/features/auth/data/models/requests/apply_request.dart';
import 'package:flower_driver/features/auth/data/models/responses/apply_response.dart';
import 'package:flutter/material.dart';
import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/core/localization/l10n/app_localizations.dart';
import 'package:flower_driver/core/values/app_strings.dart';
import 'package:flower_driver/features/auth/api/auth_api_client.dart';
import 'package:flower_driver/features/auth/api/data_source/remote/auth_remote_data_source_impl.dart';
import 'package:flower_driver/features/auth/data/models/responses/enter_email_response.dart';
import 'package:flower_driver/features/auth/data/models/responses/new_password_response.dart';
import 'package:flower_driver/features/auth/data/models/responses/verify_otp_response.dart';
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

  test('auth remote data source impl ...', () async {
    //arrange
    final file1 = File('dummy_license.jpg')..writeAsStringSync('dummy');
    final file2 = File('dummy_nid.jpg')..writeAsStringSync('dummy');
    when(
      mockApiClient.apply(
        country: anyNamed('country'),
        firstName: anyNamed('firstName'),
        lastName: anyNamed('lastName'),
        vehicleType: anyNamed('vehicleType'),
        vehicleNumber: anyNamed('vehicleNumber'),
        vehicleLicense: anyNamed('vehicleLicense'),
        nid: anyNamed('nid'),
        nidImg: anyNamed('nidImg'),
        email: anyNamed('email'),
        password: anyNamed('password'),
        rePassword: anyNamed('rePassword'),
        gender: anyNamed('gender'),
        phone: anyNamed('phone'),
      ),
    ).thenAnswer((_) async => ApplyResponse());
    //act
    final result = await remoteDataSource.apply(
      ApplyRequest(
        vehicleLicense: 'dummy_license.jpg',
        nidImg: 'dummy_nid.jpg',
      ),
    );
    //assert
    expect(result, isA<Success>());
    file1.deleteSync();
    file2.deleteSync();
  });

  group("Enter Email Tests", () {
    test("should return success", () async {
      final response = EnterEmailResponse(
        message: "Success",
        info: "Email sent",
      );

      when(mockApiClient.enterEmail(any)).thenAnswer((_) async => response);

      final result = await remoteDataSource.enterEmail(email: "test@test.com");

      expect(result, isA<Success<EnterEmailResponse>>());

      expect(
        (result as Success<EnterEmailResponse>).data.message,
        response.message,
      );

      verify(mockApiClient.enterEmail(any)).called(1);
    });

    test("should return failure", () async {
      when(mockApiClient.enterEmail(any)).thenThrow(Exception());

      final result = await remoteDataSource.enterEmail(email: "test@test.com");

      expect(result, isA<Failure<EnterEmailResponse>>());

      verify(mockApiClient.enterEmail(any)).called(1);
    });
  });

  group("Verify OTP Tests", () {
    test("should return success", () async {
      final response = VerifyOtpResponse(status: "Success");

      when(mockApiClient.verifyOtp(any)).thenAnswer((_) async => response);

      final result = await remoteDataSource.verifyOtp(otp: "123456");

      expect(result, isA<Success<VerifyOtpResponse>>());

      expect(
        (result as Success<VerifyOtpResponse>).data.status,
        response.status,
      );

      verify(mockApiClient.verifyOtp(any)).called(1);
    });

    test("should return failure", () async {
      when(mockApiClient.verifyOtp(any)).thenThrow(Exception());

      final result = await remoteDataSource.verifyOtp(otp: "123456");

      expect(result, isA<Failure<VerifyOtpResponse>>());

      verify(mockApiClient.verifyOtp(any)).called(1);
    });
  });

  group("Add New Password Tests", () {
    test("should return success", () async {
      final response = NewPasswordResponse(
        message: "Success",
        token: "token_123",
      );

      when(mockApiClient.addNewPassword(any)).thenAnswer((_) async => response);

      final result = await remoteDataSource.addNewPassword(
        email: "test@test.com",
        newPassword: "12345678",
      );

      expect(result, isA<Success<NewPasswordResponse>>());

      expect(
        (result as Success<NewPasswordResponse>).data.token,
        response.token,
      );

      verify(mockApiClient.addNewPassword(any)).called(1);
    });

    test("should return failure", () async {
      when(mockApiClient.addNewPassword(any)).thenThrow(Exception());
      final result = await remoteDataSource.addNewPassword(
        email: "test@test.com",
        newPassword: "12345678",
      );
      expect(result, isA<Failure<NewPasswordResponse>>());

      verify(mockApiClient.addNewPassword(any)).called(1);
    });
  });
}
