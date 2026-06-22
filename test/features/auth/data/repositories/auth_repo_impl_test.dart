import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/config/secure_cache/secure_cache/secure_cache.dart';
import 'package:flower_driver/features/auth/data/data_source/remote/auth_remote_data_source.dart';
import 'package:flower_driver/features/auth/data/models/requests/login_request.dart';
import 'package:flower_driver/features/auth/data/models/responses/auth_response.dart';
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

    provideDummy<Result<AuthResponse>>(
      Success(data: AuthResponse(token: "token")),
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

    test("success and save data", () async {
      when(
        mockRemote.signIn(any),
      ).thenAnswer((_) async => Success(data: tAuthResponse));

      final result = await repo.signIn(tLoginRequest, true);

      expect(result, isA<Success<AuthResponse>>());
      verify(mockRemote.signIn(tLoginRequest)).called(1);
      verify(
        mockSecureCache.saveData(
          key: anyNamed('key'),
          value: anyNamed('value'),
        ),
      ).called(2);
    });

    test("failure", () async {
      when(
        mockRemote.signIn(any),
      ).thenAnswer((_) async => Failure(errorMessage: errorMessage));

      final result = await repo.signIn(tLoginRequest, false);

      expect(result, isA<Failure<AuthResponse>>());
      expect((result as Failure<AuthResponse>).errorMessage, errorMessage);
    });
  });
}
