import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/auth/domain/repositories/auth_repo.dart';
import 'package:flower_driver/features/auth/domain/use_case/verify_otp_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'verify_otp_use_case_test.mocks.dart';

@GenerateMocks([AuthRepo])
void main() {
  late VerifyOtpUseCase verifyOtpUseCase;

  late MockAuthRepo mockAuthRepo;

  late String errorMessage;

  setUpAll(() {
    errorMessage = "Something went wrong";

    provideDummy<Result<bool>>(Success<bool>(data: true));
  });

  setUp(() {
    mockAuthRepo = MockAuthRepo();

    verifyOtpUseCase = VerifyOtpUseCase(mockAuthRepo);
  });

  group("Verify Otp UseCase Test Group", () {
    test("should return success when otp is verified", () async {
      // Arrange

      when(
        mockAuthRepo.verifyOtp(otp: anyNamed('otp')),
      ).thenAnswer((_) async => Success<bool>(data: true));

      // Act

      final result = await verifyOtpUseCase(otp: "123456");

      // Assert

      expect(result, isA<Success<bool>>());

      expect((result as Success<bool>).data, true);

      verify(mockAuthRepo.verifyOtp(otp: anyNamed('otp'))).called(1);

      verifyNoMoreInteractions(mockAuthRepo);
    });

    test("should return failure when otp verification fails", () async {
      // Arrange

      when(
        mockAuthRepo.verifyOtp(otp: anyNamed('otp')),
      ).thenAnswer((_) async => Failure<bool>(errorMessage: errorMessage));

      // Act

      final result = await verifyOtpUseCase(otp: "123456");

      // Assert

      expect(result, isA<Failure<bool>>());

      expect((result as Failure<bool>).errorMessage, errorMessage);

      verify(mockAuthRepo.verifyOtp(otp: anyNamed('otp'))).called(1);

      verifyNoMoreInteractions(mockAuthRepo);
    });
  });
}
