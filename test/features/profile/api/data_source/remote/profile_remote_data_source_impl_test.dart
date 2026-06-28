import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/profile/data/models/response/driver_data_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flower_driver/features/profile/api/data_source/api_profile.dart';
import 'package:flower_driver/features/profile/api/data_source/remote/profile_remote_data_source_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'profile_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([ApiProfile])
late ProfileRemoteDataSourceImpl dataSource;
late MockApiProfile apiProfile;
void main() {
  setUpAll(() {
    apiProfile = MockApiProfile();
    dataSource = ProfileRemoteDataSourceImpl(apiProfile);
  });

  group('ProfileRemoteDataSourceImpl', () {
    test('return success from driver when api call is successfull', () async {
      final driverResponse = DriverDataResponse(
        driver: Driver(
          id: '1',
          firstName: 'test',
          lastName: 'test',
          vehicleType: 'test',
          vehicleNumber: 'test',
          vehicleLicense: 'test',
          nid: 'test',
          nidImg: 'test',
          email: 'test',
          gender: 'test',
          phone: 'test',
          photo: 'test',
          role: 'test',
          createdAt: DateTime.now(),
          country: 'test',
        ),
        message: 'Success',
      );
      when(apiProfile.getDriverData()).thenAnswer((_) async => driverResponse);
      final result = await dataSource.getDriverData();
      expect(result, isA<Success<DriverDataResponse>>());
    });
    test('return failiure when editProfile api call is failiure', () async {
      when(
        apiProfile.getDriverData(),
      ).thenAnswer((_) async => throw Exception());
      final result = await dataSource.getDriverData();
      expect(result, isA<Failure<DriverDataResponse>>());
      verify(() => apiProfile.getDriverData()).called(1);
    });
  });
}
