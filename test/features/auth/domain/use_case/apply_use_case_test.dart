import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/auth/data/models/requests/apply_request.dart';
import 'package:flower_driver/features/auth/data/models/responses/apply_response.dart';
import 'package:flower_driver/features/auth/domain/repositories/auth_repo.dart';
import 'package:flower_driver/features/auth/domain/use_case/apply_use_case.dart';

import 'apply_use_case_test.mocks.dart';

@GenerateMocks([AuthRepo])
void main() {
  late ApplyUseCase useCase;
  late MockAuthRepo mockAuthRepo;

  setUpAll(() {
    provideDummy<Result<ApplyResponse>>(
      Success<ApplyResponse>(data: ApplyResponse()),
    );
  });

  setUp(() {
    mockAuthRepo = MockAuthRepo();
    useCase = ApplyUseCase(mockAuthRepo);
  });

  final request = ApplyRequest(
    country: 'Egypt',
    firstName: 'Jane',
    lastName: 'Smith',
    email: 'jane@example.com',
    phone: '+201111111111',
    password: 'Pass@123',
    rePassword: 'Pass@123',
    gender: 'female',
    vehicleType: 'car-id',
    vehicleNumber: 'ABC123',
    nid: '12345678901234',
  );

  group('ApplyUseCase -', () {
    test('delegates call to AuthRepo.apply and returns Success', () async {
      final expectedResponse = ApplyResponse(
        message: 'Application received',
        token: 'abc-token',
      );

      when(mockAuthRepo.apply(request)).thenAnswer(
        (_) async => Success<ApplyResponse>(data: expectedResponse),
      );

      final result = await useCase(request);

      expect(result, isA<Success<ApplyResponse>>());
      expect((result as Success<ApplyResponse>).data.token, 'abc-token');
      expect(result.data.message, 'Application received');

      verify(mockAuthRepo.apply(request)).called(1);
      verifyNoMoreInteractions(mockAuthRepo);
    });

    test('delegates call to AuthRepo.apply and returns Failure', () async {
      when(mockAuthRepo.apply(request)).thenAnswer(
        (_) async =>
            Failure<ApplyResponse>(errorMessage: 'Server error'),
      );

      final result = await useCase(request);

      expect(result, isA<Failure<ApplyResponse>>());
      expect((result as Failure<ApplyResponse>).errorMessage, 'Server error');

      verify(mockAuthRepo.apply(request)).called(1);
    });

    test('forwards the exact ApplyRequest to AuthRepo unchanged', () async {
      when(mockAuthRepo.apply(any)).thenAnswer(
        (_) async => Success<ApplyResponse>(data: ApplyResponse()),
      );

      await useCase(request);

      final captured =
          verify(mockAuthRepo.apply(captureAny)).captured.single as ApplyRequest;

      expect(captured.firstName, request.firstName);
      expect(captured.lastName, request.lastName);
      expect(captured.email, request.email);
      expect(captured.country, request.country);
      expect(captured.phone, request.phone);
      expect(captured.gender, request.gender);
      expect(captured.vehicleType, request.vehicleType);
    });

    test('returns null message/token when response fields are null', () async {
      when(mockAuthRepo.apply(request)).thenAnswer(
        (_) async => Success<ApplyResponse>(data: ApplyResponse()),
      );

      final result = await useCase(request);
      final data = (result as Success<ApplyResponse>).data;
      expect(data.message, null);
      expect(data.token, null);
      expect(data.driver, null);
    });
  });
}
