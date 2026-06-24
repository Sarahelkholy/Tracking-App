import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/auth/domain/repositories/auth_repo.dart';
import 'package:flower_driver/features/auth/domain/use_case/enter_email_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'add_new_password_use_case_test.mocks.dart';

@GenerateMocks([AuthRepo])
void main() {
  late EnterEmailUseCase useCase;
  late MockAuthRepo mockRepo;

  late String errorMessage;

  setUpAll(() {
    errorMessage = "Something went wrong";

    provideDummy<Result<bool>>(Success<bool>(data: true));
  });

  setUp(() {
    mockRepo = MockAuthRepo();
    useCase = EnterEmailUseCase(mockRepo);
  });

  group("Enter Email UseCase", () {
    test("success", () async {
      when(
        mockRepo.enterEmail(email: anyNamed('email')),
      ).thenAnswer((_) async => Success<bool>(data: true));

      final result = await useCase(email: "test@test.com");

      expect(result, isA<Success<bool>>());

      verify(mockRepo.enterEmail(email: anyNamed('email'))).called(1);
    });

    test("failure", () async {
      when(
        mockRepo.enterEmail(email: anyNamed('email')),
      ).thenAnswer((_) async => Failure<bool>(errorMessage: errorMessage));

      final result = await useCase(email: "test@test.com");

      expect(result, isA<Failure<bool>>());

      expect((result as Failure<bool>).errorMessage, errorMessage);

      verify(mockRepo.enterEmail(email: anyNamed('email'))).called(1);
    });
  });
}
