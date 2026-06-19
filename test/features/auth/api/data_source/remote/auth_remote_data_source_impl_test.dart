import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/auth/api/auth_api_client.dart';
import 'package:flower_driver/features/auth/api/data_source/remote/auth_remote_data_source_impl.dart';
import 'package:flower_driver/features/auth/data/models/requests/apply_request.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'auth_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([AuthApiClient])
void main() {
  //arrange
  late MockAuthApiClient apiClient;
  late AuthRemoteDataSourceImpl remoteDataSource;

  setUp(() {
    apiClient = MockAuthApiClient();
    remoteDataSource = AuthRemoteDataSourceImpl(apiClient);
  });

  test('auth remote data source impl ...', () async {
    //act
    final result = await remoteDataSource.apply(ApplyRequest());
    //assert
    expect(result, isA<Success>());
  });
}
