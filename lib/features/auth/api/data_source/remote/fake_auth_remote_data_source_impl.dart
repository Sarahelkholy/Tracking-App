import 'package:dio/dio.dart';
import 'package:flower_driver/features/auth/data/models/requests/apply_request.dart';
import 'package:flower_driver/features/auth/data/models/requests/login_request.dart';
import 'package:flower_driver/features/auth/data/models/responses/apply_response.dart';
import 'package:flower_driver/features/auth/data/models/responses/auth_response.dart';
import 'package:flower_driver/features/auth/data/models/responses/logout_response.dart';
import 'package:injectable/injectable.dart';

import '../../../../../config/error_handling/execute_api.dart';
import '../../../../../config/error_handling/result.dart';
import '../../../data/data_source/remote/auth_remote_data_source.dart';
import '../../../data/models/responses/enter_email_response.dart';
import '../../../data/models/responses/new_password_response.dart';
import '../../../data/models/responses/verify_otp_response.dart';
import '../../auth_api_client.dart';

@Injectable(as: AuthRemoteDataSource)
class FakeAuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthApiClient _apiClient;

  const FakeAuthRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Result<EnterEmailResponse>> enterEmail({required String email}) async {
    await Future.delayed(const Duration(seconds: 2));

    return Success(data: EnterEmailResponse(message: "OTP Sent Successfully"));
  }

  @override
  Future<Result<VerifyOtpResponse>> verifyOtp({required String otp}) async {
    await Future.delayed(const Duration(seconds: 2));

    if (otp != "123456") {
      return Failure(errorMessage: "Invalid Code");
    }

    return Success(data: VerifyOtpResponse(status: "success"));
  }

  @override
  Future<Result<NewPasswordResponse>> addNewPassword({
    required String email,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    return Success(
      data: NewPasswordResponse(message: "Password Changed Successfully"),
    );
  }

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
}
