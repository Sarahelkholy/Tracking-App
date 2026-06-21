import 'package:dio/dio.dart';
import 'package:flower_driver/config/error_handling/execute_api.dart';
import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/auth/api/auth_api_client.dart';
import 'package:flower_driver/features/auth/data/models/requests/apply_request.dart';
import 'package:flower_driver/features/auth/data/models/responses/apply_response.dart';
import 'package:flower_driver/features/auth/data/models/requests/login_request.dart';
import 'package:flower_driver/features/auth/data/models/responses/auth_response.dart';
import 'package:flower_driver/features/auth/data/models/responses/logout_response.dart';

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
  Future<Result<ApplyResponse>> apply(ApplyRequest applyRequest) {
    return executeApi(() async {
      final licenseFile = await MultipartFile.fromFile(
        applyRequest.vehicleLicense!,
        filename: applyRequest.vehicleLicense!.split('/').last,
      );
      final nidFile = await MultipartFile.fromFile(
        applyRequest.nidImg!,
        filename: applyRequest.nidImg!.split('/').last,
      );

      return _apiClient.apply(
        country: applyRequest.country ?? '',
        firstName: applyRequest.firstName ?? '',
        lastName: applyRequest.lastName ?? '',
        vehicleType: applyRequest.vehicleType ?? '',
        vehicleNumber: applyRequest.vehicleNumber ?? '',
        vehicleLicense: licenseFile,
        nid: applyRequest.nid ?? '',
        nidImg: nidFile,
        email: applyRequest.email ?? '',
        password: applyRequest.password ?? '',
        rePassword: applyRequest.rePassword ?? '',
        gender: applyRequest.gender ?? '',
        phone: applyRequest.phone ?? '',
      );
    });
  }

  @override
  Future<Result<LogoutResponse>> logout() {
    return executeApi<LogoutResponse>(() {
      return _apiClient.logout();
    });
  }

  @override
  Future<Result<AuthResponse>> signIn(LoginRequest loginRequest) {
    return executeApi(() => _apiClient.signIn(loginRequest));
  }

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
