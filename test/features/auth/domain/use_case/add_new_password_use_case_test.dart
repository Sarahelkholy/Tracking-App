import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/auth/domain/repositories/auth_repo.dart';
import 'package:flower_driver/features/auth/domain/use_case/add_new_password_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'add_new_password_use_case_test.mocks.dart';

@GenerateMocks([AuthRepo])
void main() {
  late AddNewPasswordUseCase addNewPasswordUseCase;

  late MockAuthRepo mockAuthRepo;

  late String errorMessage;

  setUpAll(() {
    errorMessage = "Something went wrong";

    provideDummy<Result<bool>>(Success<bool>(data: true));
  });

  setUp(() {
    mockAuthRepo = MockAuthRepo();

    addNewPasswordUseCase = AddNewPasswordUseCase(mockAuthRepo);
  });

  group("Add New Password UseCase Test Group", () {
    test("should return success when password changed", () async {
      // Arrange

      when(
        mockAuthRepo.addNewPassword(
          email: anyNamed('email'),
          newPassword: anyNamed('newPassword'),
        ),
      ).thenAnswer((_) async => Success<bool>(data: true));

      // Act

      final result = await addNewPasswordUseCase(
        email: "test@test.com",
        newPassword: "12345678",
      );

      // Assert

      expect(result, isA<Success<bool>>());

      expect((result as Success<bool>).data, true);

      verify(
        mockAuthRepo.addNewPassword(
          email: anyNamed('email'),
          newPassword: anyNamed('newPassword'),
        ),
      ).called(1);

      verifyNoMoreInteractions(mockAuthRepo);
    });

    test("should return failure when password change fails", () async {
      // Arrange

      when(
        mockAuthRepo.addNewPassword(
          email: anyNamed('email'),
          newPassword: anyNamed('newPassword'),
        ),
      ).thenAnswer((_) async => Failure<bool>(errorMessage: errorMessage));

      // Act

      final result = await addNewPasswordUseCase(
        email: "test@test.com",
        newPassword: "12345678",
      );

      // Assert

      expect(result, isA<Failure<bool>>());

      expect((result as Failure<bool>).errorMessage, errorMessage);

      verify(
        mockAuthRepo.addNewPassword(
          email: anyNamed('email'),
          newPassword: anyNamed('newPassword'),
        ),
      ).called(1);

      verifyNoMoreInteractions(mockAuthRepo);
    });
  });
}
