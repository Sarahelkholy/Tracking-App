import 'package:injectable/injectable.dart';

import '../../../../../config/error_handling/result.dart';
import '../../../data/data_source/remote/auth_remote_data_source.dart';
import '../../../data/models/responses/enter_email_response.dart';
import '../../../data/models/responses/new_password_response.dart';
import '../../../data/models/responses/verify_otp_response.dart';

@Injectable(as: AuthRemoteDataSource)
class FakeAuthRemoteDataSourceImpl implements AuthRemoteDataSource {
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
}
