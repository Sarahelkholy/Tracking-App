import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/profile/data/models/response/upload_profile_photo_response.dart';
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
    test(' UploadProfilePhoto succesfully', () {
      final file = File('test.jpg');
      when(mockUploadProfilePhotoUsecase.call(file)).thenAnswer(
        (_) async =>
            Success(data: UploadProfilePhotoResponse(message: 'success')),
      );
      expect(
        mockUploadProfilePhotoUsecase.call(file),
        Success(data: UploadProfilePhotoResponse(message: 'success')),
      );
    });
    test(' UploadProfilePhoto failure', () {});
    test(' SubmitEditProfile succesfully', () {});
    test(' SubmitEditProfile failure', () {});
    test(' LogoutIntent succesfully', () {});
    test(' LogoutIntent failure', () {});
  });
}
