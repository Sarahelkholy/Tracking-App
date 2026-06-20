import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/auth/data/data_source/remote/auth_remote_data_source.dart';
import 'package:flower_driver/features/auth/data/models/requests/apply_request.dart';
import 'package:flower_driver/features/auth/data/models/responses/apply_response.dart';
import 'package:flower_driver/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:flower_driver/config/secure_cache/secure_cache/secure_cache.dart';

import 'auth_repo_impl_apply_test.mocks.dart';

@GenerateMocks([AuthRemoteDataSource, SecureCache])
void main() {
  late AuthRepoImpl repo;
  late MockAuthRemoteDataSource mockDataSource;
  late MockSecureCache mockCache;

  setUpAll(() {
    provideDummy<Result<ApplyResponse>>(
      Success<ApplyResponse>(data: ApplyResponse()),
    );
  });

  setUp(() {
    mockDataSource = MockAuthRemoteDataSource();
    mockCache = MockSecureCache();
    repo = AuthRepoImpl(mockDataSource, mockCache);
  });

  final request = ApplyRequest(
    country: 'Egypt',
    firstName: 'Ali',
    lastName: 'Hassan',
    email: 'ali@example.com',
    phone: '+201234567890',
    password: 'Secure@1',
    rePassword: 'Secure@1',
    gender: 'male',
    vehicleType: 'car-id',
    vehicleNumber: 'XYZ789',
    nid: '29901010100001',
  );

  group('AuthRepoImpl.apply -', () {
    test('returns Success from data source on success', () async {
      final expectedResponse = ApplyResponse(
        message: 'Registered',
        token: 'token-xyz',
      );

      when(mockDataSource.apply(request)).thenAnswer(
        (_) async => Success<ApplyResponse>(data: expectedResponse),
      );

      final result = await repo.apply(request);

      expect(result, isA<Success<ApplyResponse>>());
      final data = (result as Success<ApplyResponse>).data;
      expect(data.message, 'Registered');
      expect(data.token, 'token-xyz');

      verify(mockDataSource.apply(request)).called(1);
      // apply() should NOT touch the cache
      verifyZeroInteractions(mockCache);
    });

    test('returns Failure from data source on failure', () async {
      when(mockDataSource.apply(request)).thenAnswer(
        (_) async =>
            Failure<ApplyResponse>(errorMessage: 'Email already exists'),
      );

      final result = await repo.apply(request);

      expect(result, isA<Failure<ApplyResponse>>());
      expect(
        (result as Failure<ApplyResponse>).errorMessage,
        'Email already exists',
      );

      verify(mockDataSource.apply(request)).called(1);
      verifyZeroInteractions(mockCache);
    });

    test('delegates the exact request to the data source', () async {
      when(mockDataSource.apply(any)).thenAnswer(
        (_) async => Success<ApplyResponse>(data: ApplyResponse()),
      );

      await repo.apply(request);

      final captured =
          verify(mockDataSource.apply(captureAny)).captured.single
              as ApplyRequest;

      expect(captured.firstName, 'Ali');
      expect(captured.email, 'ali@example.com');
      expect(captured.country, 'Egypt');
    });

    test('does not mutate SecureCache on apply', () async {
      when(mockDataSource.apply(any)).thenAnswer(
        (_) async => Success<ApplyResponse>(data: ApplyResponse()),
      );

      await repo.apply(request);

      verifyNever(mockCache.saveData(key: anyNamed('key'), value: anyNamed('value')));
      verifyNever(mockCache.removeData(key: anyNamed('key')));
    });
  });
}
