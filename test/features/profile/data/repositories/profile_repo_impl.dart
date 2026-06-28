import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/profile/data/data_source/remote/profile_remote_data_source.dart';
import 'package:flower_driver/features/profile/data/models/request/edit_profile_request.dart';
import 'package:flower_driver/features/profile/data/models/response/driver_data_response.dart';
import 'package:flower_driver/features/profile/data/models/response/edit_profile_response.dart'
    as edit_profile;
import 'package:flower_driver/features/profile/data/models/response/edit_profile_response.dart'
    hide Driver;
import 'package:flower_driver/features/profile/data/repositories/profile_repo_impl.dart';
import 'package:flower_driver/features/profile/domain/entities/profile/driver_data_entity.dart';
import 'package:flower_driver/features/profile/domain/entities/profile/edit_profile_entity.dart';
import 'package:flower_driver/features/profile/domain/repositories/profile_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mocktail/mocktail.dart' hide when, verify, any;

import 'profile_repo_impl.mocks.dart';

@GenerateMocks([ProfileRemoteDataSource])
void main() {
  late MockProfileRemoteDataSource mockProfileRemoteDataSource;
  late ProfileRepoImpl profileRepoImpl;

  setUpAll(() {
    provideDummy<Result<DriverDataResponse>>(
      Success(
        data: DriverDataResponse(
          driver: Driver(firstName: 'Rahma', lastName: 'Ashraf'),
        ),
      ),
    );
  });

  setUp(() {
    mockProfileRemoteDataSource = MockProfileRemoteDataSource();
    profileRepoImpl = ProfileRepoImpl(
      profileRemoteDataSource: mockProfileRemoteDataSource,
    );
  });

  group('get driver data', () {
    test(
      'should return success when driver data is fetched successfully',
      () async {
        when(mockProfileRemoteDataSource.getDriverData()).thenAnswer(
          (_) async =>
              Success<DriverDataResponse>(
                    data: DriverDataResponse(
                      message: "test",
                      driver: Driver(firstName: 'test', lastName: 'test'),
                    ),
                  )
                  as Result<DriverDataResponse>,
        );
        final result = await profileRepoImpl.getDriverData();
        expect(result, isA<Success<ProfileDriverEntity>>());
        verify(mockProfileRemoteDataSource.getDriverData()).called(1);
      },
    );
    test('should return failure when driver data is not fetched', () async {
      when(mockProfileRemoteDataSource.getDriverData()).thenAnswer(
        (_) async =>
            Failure<DriverDataResponse>(errorMessage: "test")
                as Result<DriverDataResponse>,
      );
      final result = await profileRepoImpl.getDriverData();
      expect(result, isA<Failure<ProfileDriverEntity>>());
    });
  });
  group('edit profile', () {
    test('should return success when edit profile is successful', () async {
      when(mockProfileRemoteDataSource.editProfile(any)).thenAnswer(
        (_) async =>
            Success<EditProfileResponse>(
                  data: EditProfileResponse(
                    message: "test",
                    driver: edit_profile.Driver(firstName: 'test', lastName: 'test'),
                  ),
                )
                as Result<EditProfileResponse>,
      );
      final result = await profileRepoImpl.editProfile(
        EditProfileRequest(
          firstName: 'test',
          lastName: 'test',
          phone: 'test',
          email: 'test',
        ),
      );
      expect(result, isA<Success<EditProfileEntity>>());
      verify(mockProfileRemoteDataSource.editProfile(any)).called(1);
    });
  });
  group('update vehicle', () {});
}
