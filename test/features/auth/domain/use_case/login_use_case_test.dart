import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/auth/data/models/requests/login_request.dart';
import 'package:flower_driver/features/auth/data/models/responses/auth_response.dart';
import 'package:flower_driver/features/auth/domain/repositories/auth_repo.dart';
import 'package:flower_driver/features/auth/domain/use_case/login_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_use_case_test.mocks.dart';

@GenerateMocks([AuthRepo])
void main() {
  late LoginUseCase useCase;
  late MockAuthRepo mockAuthRepo;

  setUpAll(() {
    provideDummy<Result<AuthResponse>>(
      Success(data: AuthResponse(token: "token")),
    );
  });

  setUp(() {
    mockAuthRepo = MockAuthRepo();
    useCase = LoginUseCase(mockAuthRepo);
  });

  const tLoginRequest =
      LoginRequest(email: 'test@test.com', password: 'password123');
  final tAuthResponse = AuthResponse(token: 'fake_token', message: 'Success');

  test('should call signIn on repository and return result', () async {
    // arrange
    when(mockAuthRepo.signIn(any, any))
        .thenAnswer((_) async => Success(data: tAuthResponse));

    // act
    final result = await useCase.call(tLoginRequest, true);

    // assert
    expect(result, isA<Success<AuthResponse>>());
    expect((result as Success<AuthResponse>).data, tAuthResponse);
    verify(mockAuthRepo.signIn(tLoginRequest, true)).called(1);
  });

  test('should return failure when repository fails', () async {
    // arrange
    when(mockAuthRepo.signIn(any, any))
        .thenAnswer((_) async => Failure(errorMessage: 'Error'));

    // act
    final result = await useCase.call(tLoginRequest, false);

    // assert
    expect(result, isA<Failure<AuthResponse>>());
    verify(mockAuthRepo.signIn(tLoginRequest, false)).called(1);
  });
}
