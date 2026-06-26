import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/core/localization/l10n/app_localizations_en.dart';
import 'package:flower_driver/core/values/app_strings.dart';
import 'package:flower_driver/features/auth/api/auth_api_client.dart';
import 'package:flower_driver/features/auth/api/data_source/remote/auth_remote_data_source_impl.dart';
import 'package:flower_driver/features/auth/data/models/requests/apply_request.dart';
import 'package:flower_driver/features/auth/data/models/requests/login_request.dart';
import 'package:flower_driver/features/auth/data/models/responses/apply_response.dart';
import 'package:flower_driver/features/auth/data/models/responses/auth_response.dart';
import 'package:flower_driver/features/auth/data/models/responses/logout_response.dart';
import 'package:flower_driver/features/auth/data/models/responses/enter_email_response.dart';
import 'package:flower_driver/features/auth/data/models/responses/new_password_response.dart';
import 'package:flower_driver/features/auth/data/models/responses/verify_otp_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([AuthApiClient])
void main() {
  late MockAuthApiClient apiClient;
  late AuthRemoteDataSourceImpl remoteDataSource;
  late Directory tempDir;
  late String tempDirPath;
  late String licenseFilePath;
  late String nidFilePath;

  setUpAll(() {
    AppStrings.current = AppLocalizationsEn();
  });

  setUp(() async {
    apiClient = MockAuthApiClient();
    remoteDataSource = AuthRemoteDataSourceImpl(apiClient);

    // Create temp files for MultipartFile testing
    tempDir = await Directory.systemTemp.createTemp('auth_test');
    tempDirPath = tempDir.path;

    final licenseFile = File('$tempDirPath/license.jpg');
    await licenseFile.writeAsString('fake license content');
    licenseFilePath = licenseFile.path;

    final nidFile = File('$tempDirPath/nid.jpg');
    await nidFile.writeAsString('fake nid content');
    nidFilePath = nidFile.path;
  });

  tearDown(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('signIn -', () {
    const loginRequest = LoginRequest(
      email: 'test@example.com',
      password: 'password123',
    );
    final authResponse = AuthResponse(
      message: 'Success',
      token: 'token123',
    );

    test('returns Success when apiClient.signIn succeeds', () async {
      when(apiClient.signIn(loginRequest)).thenAnswer((_) async => authResponse);

      final result = await remoteDataSource.signIn(loginRequest);

      expect(result, isA<Success<AuthResponse>>());
      expect((result as Success<AuthResponse>).data, authResponse);
      verify(apiClient.signIn(loginRequest)).called(1);
    });

    test('returns Failure when apiClient.signIn throws DioException', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionTimeout,
      );
      when(apiClient.signIn(loginRequest)).thenThrow(dioException);

      final result = await remoteDataSource.signIn(loginRequest);

      expect(result, isA<Failure<AuthResponse>>());
      expect(
        (result as Failure<AuthResponse>).errorMessage,
        AppStrings.current.connectionTimeoutMessage,
      );
      verify(apiClient.signIn(loginRequest)).called(1);
    });

    test('returns Failure with unexpected error message when apiClient.signIn throws non-DioException', () async {
      when(apiClient.signIn(loginRequest)).thenThrow(Exception('Unexpected error'));

      final result = await remoteDataSource.signIn(loginRequest);

      expect(result, isA<Failure<AuthResponse>>());
      expect(
        (result as Failure<AuthResponse>).errorMessage,
        AppStrings.current.unexpectedErrorMessage,
      );
      verify(apiClient.signIn(loginRequest)).called(1);
    });
  });

  group('logout -', () {
    final logoutResponse = LogoutResponse(message: 'Success');

    test('returns Success when apiClient.logout succeeds', () async {
      when(apiClient.logout()).thenAnswer((_) async => logoutResponse);

      final result = await remoteDataSource.logout();

      expect(result, isA<Success<LogoutResponse>>());
      expect((result as Success<LogoutResponse>).data, logoutResponse);
      verify(apiClient.logout()).called(1);
    });

    test('returns Failure when apiClient.logout throws DioException', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.sendTimeout,
      );
      when(apiClient.logout()).thenThrow(dioException);

      final result = await remoteDataSource.logout();

      expect(result, isA<Failure<LogoutResponse>>());
      expect(
        (result as Failure<LogoutResponse>).errorMessage,
        AppStrings.current.sendTimeoutMessage,
      );
      verify(apiClient.logout()).called(1);
    });
  });

  group('apply -', () {
    late ApplyRequest applyRequest;
    late ApplyResponse applyResponse;

    setUp(() {
      applyRequest = ApplyRequest(
        country: 'Egypt',
        firstName: 'Ali',
        lastName: 'Hassan',
        vehicleType: 'car-id',
        vehicleNumber: 'XYZ789',
        vehicleLicense: licenseFilePath,
        nid: '29901010100001',
        nidImg: nidFilePath,
        email: 'ali@example.com',
        password: 'Secure@1',
        rePassword: 'Secure@1',
        gender: 'male',
        phone: '+201234567890',
      );

      applyResponse = ApplyResponse(
        message: 'Registration successful',
        token: 'token-xyz',
      );
    });

    test('returns Success and calls apiClient.apply with correct parameters on success', () async {
      when(apiClient.apply(
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
      )).thenAnswer((_) async => applyResponse);

      final result = await remoteDataSource.apply(applyRequest);

      expect(result, isA<Success<ApplyResponse>>());
      expect((result as Success<ApplyResponse>).data, applyResponse);

      verify(apiClient.apply(
        country: argThat(equals('Egypt'), named: 'country'),
        firstName: argThat(equals('Ali'), named: 'firstName'),
        lastName: argThat(equals('Hassan'), named: 'lastName'),
        vehicleType: argThat(equals('car-id'), named: 'vehicleType'),
        vehicleNumber: argThat(equals('XYZ789'), named: 'vehicleNumber'),
        vehicleLicense: argThat(isNotNull, named: 'vehicleLicense'),
        nid: argThat(equals('29901010100001'), named: 'nid'),
        nidImg: argThat(isNotNull, named: 'nidImg'),
        email: argThat(equals('ali@example.com'), named: 'email'),
        password: argThat(equals('Secure@1'), named: 'password'),
        rePassword: argThat(equals('Secure@1'), named: 'rePassword'),
        gender: argThat(equals('male'), named: 'gender'),
        phone: argThat(equals('+201234567890'), named: 'phone'),
      )).called(1);
    });

    test('returns Failure when apiClient.apply throws DioException', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 400,
          data: {'message': 'Invalid vehicle number'},
        ),
      );

      when(apiClient.apply(
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
      )).thenThrow(dioException);

      final result = await remoteDataSource.apply(applyRequest);

      expect(result, isA<Failure<ApplyResponse>>());
      expect(
        (result as Failure<ApplyResponse>).errorMessage,
        'Invalid vehicle number',
      );

      verify(apiClient.apply(
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
      )).called(1);
    });

    test('throws Error when vehicleLicense or nidImg are null (null operator checks)', () async {
      final incompleteRequest = applyRequest.copyWith(vehicleLicense: null);

      expect(
        () => remoteDataSource.apply(incompleteRequest),
        throwsA(isA<Error>()),
      );

      verifyNever(apiClient.apply(
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
      ));
    });

    test('returns Failure when file path is invalid and throws FileSystemException', () async {
      final invalidFileRequest = applyRequest.copyWith(vehicleLicense: 'non_existent_file.jpg');

      final result = await remoteDataSource.apply(invalidFileRequest);

      expect(result, isA<Failure<ApplyResponse>>());
      expect(
        (result as Failure<ApplyResponse>).errorMessage,
        AppStrings.current.unexpectedErrorMessage,
      );

      verifyNever(apiClient.apply(
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
      ));
    });
  });

  group("Enter Email Tests", () {
    test("should return success", () async {
      final response = EnterEmailResponse(
        message: "Success",
        info: "Email sent",
      );

      when(apiClient.enterEmail(any)).thenAnswer((_) async => response);

      final result = await remoteDataSource.enterEmail(email: "test@test.com");

      expect(result, isA<Success<EnterEmailResponse>>());
      expect(
        (result as Success<EnterEmailResponse>).data.message,
        response.message,
      );

      verify(apiClient.enterEmail(any)).called(1);
    });

    test("should return failure", () async {
      when(apiClient.enterEmail(any)).thenThrow(Exception());

      final result = await remoteDataSource.enterEmail(email: "test@test.com");

      expect(result, isA<Failure<EnterEmailResponse>>());
      verify(apiClient.enterEmail(any)).called(1);
    });
  });

  group("Verify OTP Tests", () {
    test("should return success", () async {
      final response = VerifyOtpResponse(status: "Success");

      when(apiClient.verifyOtp(any)).thenAnswer((_) async => response);

      final result = await remoteDataSource.verifyOtp(otp: "123456");

      expect(result, isA<Success<VerifyOtpResponse>>());
      expect(
        (result as Success<VerifyOtpResponse>).data.status,
        response.status,
      );

      verify(apiClient.verifyOtp(any)).called(1);
    });

    test("should return failure", () async {
      when(apiClient.verifyOtp(any)).thenThrow(Exception());

      final result = await remoteDataSource.verifyOtp(otp: "123456");

      expect(result, isA<Failure<VerifyOtpResponse>>());
      verify(apiClient.verifyOtp(any)).called(1);
    });
  });

  group("Add New Password Tests", () {
    test("should return success", () async {
      final response = NewPasswordResponse(
        message: "Success",
        token: "token_123",
      );

      when(apiClient.addNewPassword(any)).thenAnswer((_) async => response);

      final result = await remoteDataSource.addNewPassword(
        email: "test@test.com",
        newPassword: "12345678",
      );

      expect(result, isA<Success<NewPasswordResponse>>());
      expect(
        (result as Success<NewPasswordResponse>).data.token,
        response.token,
      );

      verify(apiClient.addNewPassword(any)).called(1);
    });

    test("should return failure", () async {
      when(apiClient.addNewPassword(any)).thenThrow(Exception());

      final result = await remoteDataSource.addNewPassword(
        email: "test@test.com",
        newPassword: "12345678",
      );

      expect(result, isA<Failure<NewPasswordResponse>>());
      verify(apiClient.addNewPassword(any)).called(1);
    });
  });
}
