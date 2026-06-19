import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:flower_driver/features/auth/domain/use_case/apply_use_case.dart';
import 'package:flower_driver/features/auth/presentation/apply/manager/apply_cubit.dart';
import 'package:flower_driver/features/auth/presentation/apply/manager/apply_intents.dart';
import 'package:flower_driver/features/auth/data/models/requests/apply_request.dart';
import 'package:flower_driver/features/auth/data/models/responses/apply_response.dart';
import 'package:flower_driver/config/error_handling/result.dart';

import 'apply_cubit_test.mocks.dart';

@GenerateMocks([ApplyUseCase])
void main() {
  late ApplyCubit applyCubit;
  late MockApplyUseCase mockApplyUseCase;

  setUp(() {
    mockApplyUseCase = MockApplyUseCase();
    applyCubit = ApplyCubit(mockApplyUseCase);
  });

  setUpAll(() {
    provideDummy<Result<ApplyResponse>>(
      Success<ApplyResponse>(data: ApplyResponse()),
    );
  });

  tearDown(() {
    applyCubit.close();
  });

  group('ApplyCubit Intents -', () {
    blocTest<ApplyCubit, ApplyState>(
      'emits correct state when SelectCountryIntent is added',
      build: () => applyCubit,
      act: (cubit) => cubit.handleIntent(SelectCountryIntent('Egypt')),
      expect: () => [ApplyState.initial().copyWith(selectedCountry: 'Egypt')],
    );

    blocTest<ApplyCubit, ApplyState>(
      'emits correct state when SelectVehicleTypeIntent is added',
      build: () => applyCubit,
      act: (cubit) => cubit.handleIntent(SelectVehicleTypeIntent('Car')),
      expect: () => [ApplyState.initial().copyWith(selectedVehicleType: 'Car')],
    );

    blocTest<ApplyCubit, ApplyState>(
      'emits correct state when SelectGenderIntent is added',
      build: () => applyCubit,
      act: (cubit) => cubit.handleIntent(SelectGenderIntent('Male')),
      expect: () => [ApplyState.initial().copyWith(selectedGender: 'Male')],
    );

    blocTest<ApplyCubit, ApplyState>(
      'emits correct state when UploadDocumentIntent (vehicleLicense) is added',
      build: () => applyCubit,
      act: (cubit) => cubit.handleIntent(
        UploadDocumentIntent(
          DocumentType.vehicleLicense,
          'path/to/license.jpg',
        ),
      ),
      expect: () => [
        ApplyState.initial().copyWith(
          vehicleLicensePath: 'path/to/license.jpg',
        ),
      ],
    );

    blocTest<ApplyCubit, ApplyState>(
      'emits correct state when UploadDocumentIntent (nidImage) is added',
      build: () => applyCubit,
      act: (cubit) => cubit.handleIntent(
        UploadDocumentIntent(DocumentType.nidImage, 'path/to/nid.jpg'),
      ),
      expect: () => [
        ApplyState.initial().copyWith(nidImagePath: 'path/to/nid.jpg'),
      ],
    );
  });

  group('SubmitApplyIntent -', () {
    final request = ApplyRequest(
      firstName: 'John',
      lastName: 'Doe',
      email: 'john.doe@example.com',
      phone: '+201234567890',
    );

    final response = ApplyResponse(message: 'Success', token: 'dummy_token');

    blocTest<ApplyCubit, ApplyState>(
      'emits [loading, success] when apply is successful',
      build: () {
        when(
          mockApplyUseCase(request),
        ).thenAnswer((_) async => Success<ApplyResponse>(data: response));

        return applyCubit;
      },
      act: (cubit) => cubit.handleIntent(SubmitApplyIntent(request)),
      expect: () => [
        ApplyState.initial().copyWith(isLoading: true, clearError: true),
        ApplyState.initial().copyWith(
          isLoading: false,
          isSuccess: true,
          message: 'Success',
          token: 'dummy_token',
          clearError: true,
        ),
      ],
    );

    blocTest<ApplyCubit, ApplyState>(
      'emits [loading, failure] when apply fails',
      build: () {
        when(mockApplyUseCase(request)).thenAnswer(
          (_) async => Failure<ApplyResponse>(errorMessage: 'Error message'),
        );

        return applyCubit;
      },
      act: (cubit) => cubit.handleIntent(SubmitApplyIntent(request)),
      expect: () => [
        ApplyState.initial().copyWith(isLoading: true, clearError: true),
        ApplyState.initial().copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: 'Error message',
          clearError: true,
        ),
      ],
    );
  });
}
