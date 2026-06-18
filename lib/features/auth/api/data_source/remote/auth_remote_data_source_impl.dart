import 'package:flower_driver/features/auth/api/auth_api_client.dart';

import '../../../../../config/error_handling/execute_api.dart';
import '../../../../../config/error_handling/result.dart';
import '../../../data/data_source/remote/auth_remote_data_source.dart';
import '../../../data/models/requests/enter_email_request.dart';
import '../../../data/models/requests/new_password_request.dart';
import '../../../data/models/requests/verify_otp_request.dart';
import '../../../data/models/responses/enter_email_response.dart';
import '../../../data/models/responses/new_password_response.dart';
import '../../../data/models/responses/verify_otp_response.dart';

// @Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthApiClient _apiClient;

  const AuthRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Result<EnterEmailResponse>> enterEmail({required String email}) async {
    return executeApi(() async {
      final request = EnterEmailRequest(email: email);
      return await _apiClient.enterEmail(request);
    });
  }

  @override
  Future<Result<VerifyOtpResponse>> verifyOtp({required String otp}) {
    return executeApi(() async {
      final request = VerifyOtpRequest(resetCode: otp);
      return await _apiClient.verifyOtp(request);
    });
  }

  @override
  Future<Result<NewPasswordResponse>> addNewPassword({
    required String email,
    required String newPassword,
  }) {
    return executeApi(() async {
      final request = NewPasswordRequest(
        email: email,
        newPassword: newPassword,
      );
      return await _apiClient.addNewPassword(request);
    });
  }
}
