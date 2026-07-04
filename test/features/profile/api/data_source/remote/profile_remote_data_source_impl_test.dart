import 'dart:ui';
import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/core/localization/l10n/app_localizations.dart';
import 'package:flower_driver/core/values/app_strings.dart';
import 'package:flower_driver/features/profile/api/data_source/api_profile.dart';
import 'package:flower_driver/features/profile/api/data_source/remote/profile_remote_data_source_impl.dart';
import 'package:flower_driver/features/profile/data/models/request/change_password_request.dart';
import 'package:flower_driver/features/profile/data/models/response/change_password_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'profile_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([ApiProfile])
void main() {
  late ProfileRemoteDataSourceImpl remoteDataSource;
  late MockApiProfile mockApiClient;

  setUpAll(() {
    AppStrings.current = lookupAppLocalizations(const Locale('en'));
  });

  setUp(() {
    mockApiClient = MockApiProfile();
    remoteDataSource = ProfileRemoteDataSourceImpl(mockApiClient);
  });

  group("Change Password Test", () {
    test("Should return Success when API call succeeds", () async {
      final response = ChangePasswordResponse(
        message: "Password changed successfully",
        token: "123456",
      );

      when(mockApiClient.changePassword(any)).thenAnswer((_) async => response);

      final result = await remoteDataSource.changePassword(
        password: "oldPassword",
        newPassword: "newPassword",
      );

      expect(result, isA<Success<ChangePasswordResponse>>());

      final success = result as Success<ChangePasswordResponse>;

      expect(success.data.message, "Password changed successfully");

      verify(
        mockApiClient.changePassword(
          argThat(
            isA<ChangePasswordRequest>()
                .having((e) => e.password, 'password', 'oldPassword')
                .having((e) => e.newPassword, 'newPassword', 'newPassword'),
          ),
        ),
      ).called(1);
    });

    test("Should return Failure when API throws Exception", () async {
      when(mockApiClient.changePassword(any)).thenThrow(Exception());

      final result = await remoteDataSource.changePassword(
        password: "oldPassword",
        newPassword: "newPassword",
      );

      expect(result, isA<Failure<ChangePasswordResponse>>());

      verify(mockApiClient.changePassword(any)).called(1);
    });
  });
}
