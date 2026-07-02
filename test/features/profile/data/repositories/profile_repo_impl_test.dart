import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/profile/data/data_source/remote/profile_remote_data_source.dart';
import 'package:flower_driver/features/profile/data/models/request/edit_profile_request.dart';
import 'package:flower_driver/features/profile/data/models/response/change_password_response.dart';
import 'package:flower_driver/features/profile/data/models/response/driver_data_response.dart';
import 'package:flower_driver/features/profile/data/models/response/edit_profile_response.dart'
    as edit_profile;
import 'package:flower_driver/features/profile/data/repositories/profile_repo_impl.dart';
import 'package:flower_driver/features/profile/domain/entities/change_password/change_password_request_entity.dart';
import 'package:flower_driver/features/profile/domain/entities/profile/driver_data_entity.dart';
import 'package:flower_driver/features/profile/domain/entities/profile/edit_profile_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'profile_repo_impl_test.mocks.dart';

@GenerateMocks([ProfileRemoteDataSource])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProfileRepoImpl repo;
  late MockProfileRemoteDataSource mockRemoteDataSource;

  setUpAll(() {
    provideDummy<Result<ChangePasswordResponse>>(
      Success(data: ChangePasswordResponse()),
    );
    provideDummy<Result<DriverDataResponse>>(
      Success(data: DriverDataResponse()),
    );
    provideDummy<Result<edit_profile.EditProfileResponse>>(
      Success(data: edit_profile.EditProfileResponse()),
    );
  });

  setUp(() {
    mockRemoteDataSource = MockProfileRemoteDataSource();
    repo = ProfileRepoImpl(mockRemoteDataSource);
  });

  group('Change Password Repo Tests', () {
    test('should return Success when datasource returns success', () async {
      final response = ChangePasswordResponse(
        message: 'Password changed successfully',
        token: '',
      );

      when(
        mockRemoteDataSource.changePassword(
          password: anyNamed('password'),
          newPassword: anyNamed('newPassword'),
        ),
      ).thenAnswer(
        (_) async => Success<ChangePasswordResponse>(data: response),
      );

      final result = await repo.changePassword(
        password: 'oldPassword',
        newPassword: 'newPassword',
      );

      expect(result, isA<Success<ChangePasswordEntity>>());

      verify(
        mockRemoteDataSource.changePassword(
          password: 'oldPassword',
          newPassword: 'newPassword',
        ),
      ).called(1);

      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('should return Failure when datasource returns failure', () async {
      when(
        mockRemoteDataSource.changePassword(
          password: anyNamed('password'),
          newPassword: anyNamed('newPassword'),
        ),
      ).thenAnswer(
        (_) async =>
            Failure<ChangePasswordResponse>(errorMessage: 'Invalid password'),
      );

      final result = await repo.changePassword(
        password: 'oldPassword',
        newPassword: 'newPassword',
      );

      expect(result, isA<Failure<ChangePasswordEntity>>());

      final failure = result as Failure<ChangePasswordEntity>;

      expect(failure.errorMessage, 'Invalid password');

      verify(
        mockRemoteDataSource.changePassword(
          password: 'oldPassword',
          newPassword: 'newPassword',
        ),
      ).called(1);

      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });

  group('get driver data', () {
    test(
      'should return success when driver data is fetched successfully',
      () async {
        when(mockRemoteDataSource.getDriverData()).thenAnswer(
          (_) async =>
              Success<DriverDataResponse>(
                    data: DriverDataResponse(
                      message: "test",
                      driver: Driver(firstName: 'test', lastName: 'test'),
                    ),
                  )
                  as Result<DriverDataResponse>,
        );
        final result = await repo.getDriverData();
        expect(result, isA<Success<ProfileDriverEntity>>());
        verify(mockRemoteDataSource.getDriverData()).called(1);
      },
    );
    test('should return failure when driver data is not fetched', () async {
      when(mockRemoteDataSource.getDriverData()).thenAnswer(
        (_) async =>
            Failure<DriverDataResponse>(errorMessage: "test")
                as Result<DriverDataResponse>,
      );
      final result = await repo.getDriverData();
      expect(result, isA<Failure<ProfileDriverEntity>>());
    });
  });
  group('edit profile', () {
    test('should return success when edit profile is successful', () async {
      when(mockRemoteDataSource.editProfile(any)).thenAnswer(
        (_) async =>
            Success<edit_profile.EditProfileResponse>(
                  data: edit_profile.EditProfileResponse(
                    message: "test",
                    driver: edit_profile.Driver(
                      firstName: 'test',
                      lastName: 'test',
                    ),
                  ),
                )
                as Result<edit_profile.EditProfileResponse>,
      );
      final result = await repo.editProfile(
        EditProfileRequest(
          firstName: 'test',
          lastName: 'test',
          phone: 'test',
          email: 'test',
        ),
      );
      expect(result, isA<Success<EditProfileEntity>>());
      verify(mockRemoteDataSource.editProfile(any)).called(1);
    });
  });
}
