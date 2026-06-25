import 'package:flower_driver/features/auth/presentation/manager/apply_cubit/apply_cubit.dart';
import 'package:flower_driver/features/auth/presentation/manager/apply_cubit/apply_intents.dart';
import 'package:flower_driver/features/auth/domain/entities/country_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:flower_driver/features/auth/domain/use_case/apply_use_case.dart';
import 'package:flower_driver/features/auth/domain/use_case/get_all_countries_use_case.dart';
import 'package:flower_driver/features/auth/data/models/requests/apply_request.dart';
import 'package:flower_driver/features/auth/data/models/responses/apply_response.dart';
import 'package:flower_driver/features/auth/data/models/responses/country_model.dart';
import 'package:flower_driver/config/error_handling/result.dart';

import 'apply_cubit_test.mocks.dart';

@GenerateMocks([ApplyUseCase, GetAllCountriesUseCase])
void main() {
  late ApplyCubit applyCubit;
  late MockApplyUseCase mockApplyUseCase;
  late MockGetAllCountriesUseCase mockGetAllCountriesUseCase;

  setUpAll(() {
    provideDummy<Result<ApplyResponse>>(
      Success<ApplyResponse>(data: ApplyResponse()),
    );
    provideDummy<Result<List<CountryModel>>>(
      Success<List<CountryModel>>(data: const []),
    );
  });

  setUp(() {
    mockApplyUseCase = MockApplyUseCase();
    mockGetAllCountriesUseCase = MockGetAllCountriesUseCase();
    when(mockGetAllCountriesUseCase()).thenAnswer(
      (_) async => Success<List<CountryModel>>(
        data: [
          CountryModel(name: 'Egypt'),
          CountryModel(name: 'UAE'),
          CountryModel(name: 'Saudi Arabia'),
          CountryModel(name: 'Kuwait'),
        ],
      ),
    );
    applyCubit = ApplyCubit(mockApplyUseCase, mockGetAllCountriesUseCase);
  });

  tearDown(() {
    applyCubit.close();
  });

  // ─── Initial State ──────────────────────────────────────────────────────────

  group('ApplyState.initial -', () {
    test('has correct default values', () {
      final state = ApplyState.initial();
      expect(state.isLoading, false);
      expect(state.isSuccess, false);
      expect(state.errorMessage, null);
      expect(state.message, null);
      expect(state.token, null);
      expect(state.driver, null);
      expect(state.selectedCountry, 'Egypt');
      expect(state.selectedVehicleType, 'Car');
      expect(state.selectedGender, 'Male');
      expect(state.vehicleLicensePath, null);
      expect(state.nidImagePath, null);
    });
  });

  // ─── copyWith & Equatable ────────────────────────────────────────────────────

  group('ApplyState.copyWith -', () {
    test('preserves unchanged fields', () {
      final original = ApplyState.initial();
      final updated = original.copyWith(selectedCountry: 'UAE');
      expect(updated.selectedCountry, 'UAE');
      expect(updated.selectedGender, original.selectedGender);
      expect(updated.selectedVehicleType, original.selectedVehicleType);
      expect(updated.isLoading, original.isLoading);
    });

    test('clearError=true sets errorMessage to null', () {
      final stateWithError = ApplyState.initial().copyWith(
        errorMessage: 'some error',
      );
      expect(stateWithError.errorMessage, 'some error');

      final cleared = stateWithError.copyWith(clearError: true);
      expect(cleared.errorMessage, null);
    });

    test('clearError=false keeps errorMessage intact', () {
      final stateWithError = ApplyState.initial().copyWith(
        errorMessage: 'some error',
      );
      final unchanged = stateWithError.copyWith(isLoading: true);
      expect(unchanged.errorMessage, 'some error');
    });

    test('two identical states are equal (Equatable)', () {
      expect(ApplyState.initial(), equals(ApplyState.initial()));
    });

    test('different selectedCountry produces unequal states', () {
      final a = ApplyState.initial();
      final b = ApplyState.initial().copyWith(selectedCountry: 'UAE');
      expect(a, isNot(equals(b)));
    });

    test('different errorMessage produces unequal states', () {
      final a = ApplyState.initial().copyWith(errorMessage: 'err');
      final b = ApplyState.initial();
      expect(a, isNot(equals(b)));
    });
  });

  // ─── SelectCountryIntent ─────────────────────────────────────────────────────

  group('SelectCountryIntent -', () {
    blocTest<ApplyCubit, ApplyState>(
      'emits updated selectedCountry when country exists',
      build: () {
        when(mockGetAllCountriesUseCase()).thenAnswer(
          (_) async => Success<List<CountryModel>>(
            data: [
              CountryModel(name: 'Egypt'),
              CountryModel(name: 'UAE'),
            ],
          ),
        );
        return applyCubit;
      },
      act: (cubit) => cubit.handleIntent(SelectCountryIntent('Egypt')),
      expect: () => [
        ApplyState.initial().copyWith(
          selectedCountry: 'Egypt',
          countryEntity: const [
            CountryEntity(name: 'Egypt', code: '', flagUrl: ''),
            CountryEntity(name: 'UAE', code: '', flagUrl: ''),
          ],
        ),
      ],
    );

    blocTest<ApplyCubit, ApplyState>(
      'can switch countries sequentially',
      build: () {
        when(mockGetAllCountriesUseCase()).thenAnswer(
          (_) async => Success<List<CountryModel>>(
            data: [
              CountryModel(name: 'Egypt'),
              CountryModel(name: 'UAE'),
            ],
          ),
        );
        return applyCubit;
      },
      act: (cubit) async {
        await cubit.handleIntent(SelectCountryIntent('Egypt'));
        await cubit.handleIntent(SelectCountryIntent('UAE'));
      },
      expect: () => [
        ApplyState.initial().copyWith(
          selectedCountry: 'Egypt',
          countryEntity: const [
            CountryEntity(name: 'Egypt', code: '', flagUrl: ''),
            CountryEntity(name: 'UAE', code: '', flagUrl: ''),
          ],
        ),
        ApplyState.initial().copyWith(
          selectedCountry: 'UAE',
          countryEntity: const [
            CountryEntity(name: 'Egypt', code: '', flagUrl: ''),
            CountryEntity(name: 'UAE', code: '', flagUrl: ''),
          ],
        ),
      ],
    );
  });

  // ─── SelectVehicleTypeIntent ─────────────────────────────────────────────────

  group('SelectVehicleTypeIntent -', () {
    blocTest<ApplyCubit, ApplyState>(
      'emits updated selectedVehicleType',
      build: () => applyCubit,
      act: (cubit) => cubit.handleIntent(SelectVehicleTypeIntent('Car')),
      expect: () => [ApplyState.initial().copyWith(selectedVehicleType: 'Car')],
    );

    blocTest<ApplyCubit, ApplyState>(
      'can switch to Motorbike',
      build: () => applyCubit,
      act: (cubit) => cubit.handleIntent(SelectVehicleTypeIntent('Motorbike')),
      expect: () => [
        ApplyState.initial().copyWith(selectedVehicleType: 'Motorbike'),
      ],
    );

    blocTest<ApplyCubit, ApplyState>(
      'can switch to Bicycle',
      build: () => applyCubit,
      act: (cubit) => cubit.handleIntent(SelectVehicleTypeIntent('Bicycle')),
      expect: () => [
        ApplyState.initial().copyWith(selectedVehicleType: 'Bicycle'),
      ],
    );
  });

  // ─── SelectGenderIntent ──────────────────────────────────────────────────────

  group('SelectGenderIntent -', () {
    blocTest<ApplyCubit, ApplyState>(
      'emits Male gender',
      build: () => applyCubit,
      act: (cubit) => cubit.handleIntent(SelectGenderIntent('Male')),
      expect: () => [ApplyState.initial().copyWith(selectedGender: 'Male')],
    );

    blocTest<ApplyCubit, ApplyState>(
      'emits Female gender',
      build: () => applyCubit,
      act: (cubit) => cubit.handleIntent(SelectGenderIntent('Female')),
      expect: () => [ApplyState.initial().copyWith(selectedGender: 'Female')],
    );
  });

  // ─── UploadDocumentIntent ────────────────────────────────────────────────────

  group('UploadDocumentIntent -', () {
    blocTest<ApplyCubit, ApplyState>(
      'vehicleLicense sets vehicleLicensePath',
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
      'nidImage sets nidImagePath',
      build: () => applyCubit,
      act: (cubit) => cubit.handleIntent(
        UploadDocumentIntent(DocumentType.nidImage, 'path/to/nid.jpg'),
      ),
      expect: () => [
        ApplyState.initial().copyWith(nidImagePath: 'path/to/nid.jpg'),
      ],
    );

    blocTest<ApplyCubit, ApplyState>(
      'uploading both documents accumulates both paths',
      build: () => applyCubit,
      act: (cubit) {
        cubit.handleIntent(
          UploadDocumentIntent(DocumentType.vehicleLicense, 'license.jpg'),
        );
        cubit.handleIntent(
          UploadDocumentIntent(DocumentType.nidImage, 'nid.jpg'),
        );
      },
      expect: () => [
        ApplyState.initial().copyWith(vehicleLicensePath: 'license.jpg'),
        ApplyState.initial().copyWith(
          vehicleLicensePath: 'license.jpg',
          nidImagePath: 'nid.jpg',
        ),
      ],
    );

    blocTest<ApplyCubit, ApplyState>(
      'replacing vehicleLicense path overwrites previous path',
      build: () => applyCubit,
      act: (cubit) {
        cubit.handleIntent(
          UploadDocumentIntent(DocumentType.vehicleLicense, 'old.jpg'),
        );
        cubit.handleIntent(
          UploadDocumentIntent(DocumentType.vehicleLicense, 'new.jpg'),
        );
      },
      verify: (cubit) {
        expect(cubit.state.vehicleLicensePath, 'new.jpg');
      },
    );
  });

  // ─── SubmitApplyIntent ───────────────────────────────────────────────────────

  group('SubmitApplyIntent -', () {
    final request = ApplyRequest(
      firstName: 'John',
      lastName: 'Doe',
      email: 'john.doe@example.com',
      phone: '+201234567890',
    );

    final driver = Driver(
      firstName: 'John',
      lastName: 'Doe',
      email: 'john.doe@example.com',
    );

    final successResponse = ApplyResponse(
      message: 'Success',
      token: 'dummy_token',
      driver: driver,
    );

    blocTest<ApplyCubit, ApplyState>(
      'emits [loading, success] when apply succeeds',
      build: () {
        when(mockApplyUseCase(request)).thenAnswer(
          (_) async => Success<ApplyResponse>(data: successResponse),
        );
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
          driver: driver,
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
        ),
      ],
    );

    blocTest<ApplyCubit, ApplyState>(
      'failure state has isSuccess=false and isLoading=false',
      build: () {
        when(mockApplyUseCase(request)).thenAnswer(
          (_) async => Failure<ApplyResponse>(errorMessage: 'Network error'),
        );
        return applyCubit;
      },
      act: (cubit) => cubit.handleIntent(SubmitApplyIntent(request)),
      verify: (cubit) {
        expect(cubit.state.isSuccess, false);
        expect(cubit.state.isLoading, false);
        expect(cubit.state.errorMessage, 'Network error');
      },
    );

    blocTest<ApplyCubit, ApplyState>(
      'success state clears errorMessage from a previous failure',
      build: () {
        var callCount = 0;
        when(mockApplyUseCase(request)).thenAnswer((_) async {
          callCount++;
          if (callCount == 1) {
            return Failure<ApplyResponse>(errorMessage: 'Temporary error');
          }
          return Success<ApplyResponse>(data: successResponse);
        });
        return applyCubit;
      },
      act: (cubit) async {
        cubit.handleIntent(SubmitApplyIntent(request));
        // Wait for the first async call to settle before the second
        await Future<void>.delayed(const Duration(milliseconds: 10));
        cubit.handleIntent(SubmitApplyIntent(request));
        await Future<void>.delayed(const Duration(milliseconds: 10));
      },
      verify: (cubit) {
        expect(cubit.state.errorMessage, null);
        expect(cubit.state.isSuccess, true);
      },
    );

    blocTest<ApplyCubit, ApplyState>(
      'does not emit success after cubit is closed',
      build: () {
        when(mockApplyUseCase(request)).thenAnswer((_) async {
          await Future<void>.delayed(const Duration(milliseconds: 50));
          return Success<ApplyResponse>(data: successResponse);
        });
        return applyCubit;
      },
      act: (cubit) async {
        cubit.handleIntent(SubmitApplyIntent(request));
        await cubit.close();
      },
      // Only the loading emission before close should appear
      expect: () => [
        ApplyState.initial().copyWith(isLoading: true, clearError: true),
      ],
      errors: () => [],
    );
  });

  // ─── Combined intents ────────────────────────────────────────────────────────

  group('Combined intents -', () {
    blocTest<ApplyCubit, ApplyState>(
      'country + gender accumulates without resetting each other',
      build: () => applyCubit,
      act: (cubit) async {
        await cubit.handleIntent(SelectCountryIntent('Saudi Arabia'));
        cubit.handleIntent(SelectGenderIntent('Female'));
      },
      expect: () => [
        ApplyState.initial().copyWith(
          selectedCountry: 'Saudi Arabia',
          countryEntity: const [
            CountryEntity(name: 'Egypt', code: '', flagUrl: ''),
            CountryEntity(name: 'UAE', code: '', flagUrl: ''),
            CountryEntity(name: 'Saudi Arabia', code: '', flagUrl: ''),
            CountryEntity(name: 'Kuwait', code: '', flagUrl: ''),
          ],
        ),
        ApplyState.initial().copyWith(
          selectedCountry: 'Saudi Arabia',
          selectedGender: 'Female',
          countryEntity: const [
            CountryEntity(name: 'Egypt', code: '', flagUrl: ''),
            CountryEntity(name: 'UAE', code: '', flagUrl: ''),
            CountryEntity(name: 'Saudi Arabia', code: '', flagUrl: ''),
            CountryEntity(name: 'Kuwait', code: '', flagUrl: ''),
          ],
        ),
      ],
    );

    blocTest<ApplyCubit, ApplyState>(
      'all five selection intents accumulate correctly',
      build: () => applyCubit,
      act: (cubit) async {
        await cubit.handleIntent(SelectCountryIntent('Kuwait'));
        cubit.handleIntent(SelectVehicleTypeIntent('Bicycle'));
        cubit.handleIntent(SelectGenderIntent('Female'));
        cubit.handleIntent(
          UploadDocumentIntent(DocumentType.vehicleLicense, 'lic.jpg'),
        );
        cubit.handleIntent(
          UploadDocumentIntent(DocumentType.nidImage, 'nid.jpg'),
        );
      },
      verify: (cubit) {
        expect(cubit.state.selectedCountry, 'Kuwait');
        expect(cubit.state.selectedVehicleType, 'Bicycle');
        expect(cubit.state.selectedGender, 'Female');
        expect(cubit.state.vehicleLicensePath, 'lic.jpg');
        expect(cubit.state.nidImagePath, 'nid.jpg');
        expect(cubit.state.isLoading, false);
        expect(cubit.state.isSuccess, false);
      },
    );
  });
}
