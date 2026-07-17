import 'dart:io';
import 'package:bloc_test/bloc_test.dart';
import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/profile/data/models/request/edit_profile_request.dart';
import 'package:flower_driver/features/profile/data/models/response/upload_profile_photo_response.dart';
import 'package:flower_driver/features/profile/domain/entities/profile/edit_profile_entity.dart';
import 'package:flower_driver/features/profile/domain/use_case/edit_profile_usecase.dart';
import 'package:flower_driver/features/profile/domain/use_case/get_driver_data_usecase.dart';
import 'package:flower_driver/features/profile/domain/use_case/upload_profile_photo_usecase.dart';
import 'package:flower_driver/features/profile/presentation/manager/profile/profile_cubit.dart';
import 'package:flower_driver/features/profile/presentation/manager/profile/profile_intent.dart';
import 'package:flower_driver/features/profile/presentation/manager/profile/profile_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flower_driver/features/profile/domain/entities/profile/driver_data_entity.dart';

import 'profile_cubit_test.mocks.dart';

@GenerateMocks([
  GetDriverDataUsecase,
  EditProfileUsecase,
  UploadProfilePhotoUsecase,
])
void main() {
  late ProfileCubit cubit;
  late MockGetDriverDataUsecase mockGetDriverDataUsecase;
  late MockEditProfileUsecase mockEditProfileUsecase;
  late MockUploadProfilePhotoUsecase mockUploadProfilePhotoUsecase;

  late String errorMessage;

  setUpAll(() {
    errorMessage = 'something went wrong';
    provideDummy<Result<bool>>(Success(data: true));
    provideDummy<Result<ProfileDriverEntity>>(Failure(errorMessage: 'dummy'));
    provideDummy<Result<UploadProfilePhotoResponse>>(
      Failure(errorMessage: 'dummy'),
    );
    provideDummy<Result<EditProfileEntity>>(
      Success(data: const EditProfileEntity(message: 'dummy')),
    );
    provideDummy<Result<EditProfileEntity>>(Failure(errorMessage: 'dummy'));
  });

  setUp(() {
    mockGetDriverDataUsecase = MockGetDriverDataUsecase();
    mockEditProfileUsecase = MockEditProfileUsecase();
    mockUploadProfilePhotoUsecase = MockUploadProfilePhotoUsecase();
    cubit = ProfileCubit(
      mockGetDriverDataUsecase,
      mockEditProfileUsecase,
      mockUploadProfilePhotoUsecase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('Profile cubit test group', () {
    test('initial state should be ProfileInitial', () {
      expect(cubit.state, const ProfileInitial());
    });
    blocTest<ProfileCubit, ProfileState>(
      "loading state",
      setUp: () {
        when(
          mockGetDriverDataUsecase.execute(),
        ).thenAnswer((_) async => Failure(errorMessage: errorMessage));
      },
      build: () {
        return cubit;
      },
      act: (bloc) {
        cubit.handleIntent(const LoadProfileData());
      },
      expect: () => [
        isA<ProfileLoading>(),
        isA<ProfileError>().having((e) => e.message, 'message', errorMessage),
      ],
      verify: (bloc) {
        verify(mockGetDriverDataUsecase.execute());
      },
    );
    blocTest<ProfileCubit, ProfileState>(
      "UploadProfilePhoto succesfully",
      setUp: () {
        when(mockUploadProfilePhotoUsecase.call(any)).thenAnswer(
          (_) async =>
              Success(data: UploadProfilePhotoResponse(message: 'success')),
        );
        when(
          mockGetDriverDataUsecase.execute(),
        ).thenAnswer((_) async => Failure(errorMessage: errorMessage));
      },
      build: () => cubit,
      act: (bloc) {
        cubit.handleIntent(UploadProfilePhotoIntent(File('test.jpg')));
      },
      expect: () => [
        isA<UploadProfilePhotoLoading>(),
        isA<UploadProfilePhotoSuccess>(),
        isA<ProfileLoading>(),
        isA<ProfileError>().having((e) => e.message, 'message', errorMessage),
      ],
      verify: (bloc) {
        verify(mockUploadProfilePhotoUsecase.call(any));
        verify(mockGetDriverDataUsecase.execute());
      },
    );

    blocTest<ProfileCubit, ProfileState>(
      "UploadProfilePhoto failure",
      setUp: () {
        when(
          mockUploadProfilePhotoUsecase.call(any),
        ).thenAnswer((_) async => Failure(errorMessage: 'error'));
      },
      build: () {
        return cubit;
      },
      act: (bloc) {
        cubit.handleIntent(UploadProfilePhotoIntent(File('test.jpg')));
      },
      expect: () => [
        isA<UploadProfilePhotoLoading>(),
        isA<UploadProfilePhotoError>().having(
          (e) => e.message,
          'message',
          'error',
        ),
      ],
      verify: (bloc) {
        verify(mockUploadProfilePhotoUsecase.call(any));
      },
    );
    blocTest<ProfileCubit, ProfileState>(
      'EditProfile succesfully',
      setUp: () {
        when(mockEditProfileUsecase.execute(any)).thenAnswer((_) async {
          return Success(data: const EditProfileEntity(message: 'success'));
        });
        when(
          mockGetDriverDataUsecase.execute(),
        ).thenAnswer((_) async => Failure(errorMessage: errorMessage));
      },
      build: () {
        return cubit;
      },
      act: (bloc) {
        cubit.handleIntent(
          SubmitEditProfile(EditProfileRequest(lastName: 'Ashraf')),
        );
      },
      expect: () => [
        isA<EditProfileLoading>(),
        isA<EditProfileSuccess>(),
        isA<ProfileLoading>(),
        isA<ProfileError>().having((e) => e.message, 'message', errorMessage),
      ],
      verify: (bloc) {
        verify(mockEditProfileUsecase.execute(any));
        verify(mockGetDriverDataUsecase.execute());
      },
    );

    blocTest<ProfileCubit, ProfileState>(
      ' EditProfile failure',
      setUp: () {
        when(
          mockEditProfileUsecase.execute(any),
        ).thenAnswer((_) async => Failure(errorMessage: errorMessage));
      },

      build: () {
        return cubit;
      },
      act: (bloc) {
        cubit.handleIntent(
          SubmitEditProfile(EditProfileRequest(lastName: 'Ashraf')),
        );
      },
      expect: () => [
        isA<EditProfileLoading>(),
        isA<EditProfileError>().having(
          (e) => e.message,
          'message',
          errorMessage,
        ),
      ],
      verify: (bloc) {
        verify(mockEditProfileUsecase.execute(any));
      },
    );
  });
}
