import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/profile/data/data_source/remote/profile_remote_data_source.dart';
import 'package:flower_driver/features/profile/data/models/response/change_password_response.dart';
import 'package:flower_driver/features/profile/data/repositories/profile_repo_impl.dart';
import 'package:flower_driver/features/profile/domain/entities/change_password/change_password_request_entity.dart';
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
      Success(
        data: ChangePasswordResponse(),
      ),
    );
  });

  setUp(() {
    mockRemoteDataSource = MockProfileRemoteDataSource();
    repo = ProfileRepoImpl(mockRemoteDataSource);
  });

  group('Change Password Repo Tests', () {
    test(
      'should return Success when datasource returns success',
          () async {

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
              (_) async => Success<ChangePasswordResponse>(
            data: response,
          ),
        );

        final result = await repo.changePassword(
          password: 'oldPassword',
          newPassword: 'newPassword',
        );


        expect(
          result,
          isA<Success<ChangePasswordEntity>>(),
        );

        verify(
          mockRemoteDataSource.changePassword(
            password: 'oldPassword',
            newPassword: 'newPassword',
          ),
        ).called(1);

        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );

    test(
      'should return Failure when datasource returns failure',
          () async {

        when(
          mockRemoteDataSource.changePassword(
            password: anyNamed('password'),
            newPassword: anyNamed('newPassword'),
          ),
        ).thenAnswer(
              (_) async => Failure<ChangePasswordResponse>(
            errorMessage: 'Invalid password',
          ),
        );

        final result = await repo.changePassword(
          password: 'oldPassword',
          newPassword: 'newPassword',
        );


        expect(
          result,
          isA<Failure<ChangePasswordEntity>>(),
        );

        final failure = result as Failure<ChangePasswordEntity>;

        expect(
          failure.errorMessage,
          'Invalid password',
        );

        verify(
          mockRemoteDataSource.changePassword(
            password: 'oldPassword',
            newPassword: 'newPassword',
          ),
        ).called(1);

        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );
  });
}