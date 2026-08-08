import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/config/secure_cache/secure_cache/secure_cache.dart';
import 'package:flower_driver/features/auth/data/data_source/remote/auth_remote_data_source.dart';
import 'package:flower_driver/features/auth/data/models/requests/login_request.dart';
import 'package:flower_driver/features/auth/data/models/responses/auth_response.dart';
import 'package:flower_driver/features/auth/data/models/responses/enter_email_response.dart';
import 'package:flower_driver/features/auth/data/models/responses/new_password_response.dart';
import 'package:flower_driver/features/auth/data/models/responses/verify_otp_response.dart';
import 'package:flower_driver/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_repo_impl_test.mocks.dart';

@GenerateMocks([AuthRemoteDataSource, SecureCache])
void main() {
  late AuthRepoImpl repo;
  late MockAuthRemoteDataSource mockRemote;
  late MockSecureCache mockSecureCache;

  late String errorMessage;

  setUpAll(() {
    errorMessage = "Something went wrong";

    provideDummy<Result<EnterEmailResponse>>(
      Success(data: EnterEmailResponse()),
    );

    provideDummy<Result<VerifyOtpResponse>>(Success(data: VerifyOtpResponse()));

    provideDummy<Result<NewPasswordResponse>>(
      Success(data: NewPasswordResponse()),
    );
    
    provideDummy<Result<AuthResponse>>(
      Success(data: AuthResponse()),
    );
  });

  setUp(() {
    mockRemote = MockAuthRemoteDataSource();
    mockSecureCache = MockSecureCache();
    repo = AuthRepoImpl(mockRemote, mockSecureCache);
  });

  group("SignIn Tests", () {
    const tLoginRequest = LoginRequest(
      email: 'test@test.com',
      password: 'password123',
    );
    final tAuthResponse = AuthResponse(token: 'fake_token', message: 'Success');

    test("success and save token", () async {
      when(mockRemote.signIn(any))
          .thenAnswer((_) async => Success(data: tAuthResponse));

      final result = await repo.signIn(tLoginRequest, true);

      expect(result, isA<Success<AuthResponse>>());
      expect((result as Success<AuthResponse>).data, tAuthResponse);
      
      verify(mockRemote.signIn(tLoginRequest)).called(1);
      verify(mockSecureCache.saveData(key: anyNamed('key'), value: anyNamed('value'))).called(2);
    });

    test("failure", () async {
      when(mockRemote.signIn(any))
          .thenAnswer((_) async => Failure(errorMessage: errorMessage));

      final result = await repo.signIn(tLoginRequest, false);

      expect(result, isA<Failure<AuthResponse>>());
      expect((result as Failure<AuthResponse>).errorMessage, errorMessage);
    });
  });

  group("Enter Email Tests", () {
    test("success", () async {
      when(
        mockRemote.enterEmail(email: anyNamed('email')),
      ).thenAnswer((_) async => Success(data: EnterEmailResponse()));

      final result = await repo.enterEmail(email: "test@test.com");

      expect(result, isA<Success<bool>>());
      expect((result as Success<bool>).data, true);

      verify(mockRemote.enterEmail(email: anyNamed('email'))).called(1);
    });

    test("failure", () async {
      when(
        mockRemote.enterEmail(email: anyNamed('email')),
      ).thenAnswer((_) async => Failure(errorMessage: errorMessage));

      final result = await repo.enterEmail(email: "test@test.com");

      expect(result, isA<Failure<bool>>());
      expect((result as Failure<bool>).errorMessage, errorMessage);
    });
  });

  group("Verify OTP Tests", () {
    test("success", () async {
      when(
        mockRemote.verifyOtp(otp: anyNamed('otp')),
      ).thenAnswer((_) async => Success(data: VerifyOtpResponse()));

      final result = await repo.verifyOtp(otp: "123456");

      expect(result, isA<Success<bool>>());
      expect((result as Success<bool>).data, true);

      verify(mockRemote.verifyOtp(otp: anyNamed('otp'))).called(1);
    });

    test("failure", () async {
      when(
        mockRemote.verifyOtp(otp: anyNamed('otp')),
      ).thenAnswer((_) async => Failure(errorMessage: errorMessage));

      final result = await repo.verifyOtp(otp: "123456");

      expect(result, isA<Failure<bool>>());
      expect((result as Failure<bool>).errorMessage, errorMessage);
    });
  });

  group("Add New Password Tests", () {
    test("success", () async {
      when(
        mockRemote.addNewPassword(
          email: anyNamed('email'),
          newPassword: anyNamed('newPassword'),
        ),
      ).thenAnswer((_) async => Success(data: NewPasswordResponse()));

      final result = await repo.addNewPassword(
        email: "test@test.com",
        newPassword: "12345678",
      );

      expect(result, isA<Success<bool>>());
      expect((result as Success<bool>).data, true);

      verify(
        mockRemote.addNewPassword(
          email: anyNamed('email'),
          newPassword: anyNamed('newPassword'),
        ),
      ).called(1);
    });

    test("failure", () async {
      when(
        mockRemote.addNewPassword(
          email: anyNamed('email'),
          newPassword: anyNamed('newPassword'),
        ),
      ).thenAnswer((_) async => Failure(errorMessage: errorMessage));

      final result = await repo.addNewPassword(
        email: "test@test.com",
        newPassword: "12345678",
      );

      expect(result, isA<Failure<bool>>());
      expect((result as Failure<bool>).errorMessage, errorMessage);
    });
  });
}
