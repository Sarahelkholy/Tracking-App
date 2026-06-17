import 'package:flower_driver/features/auth/data/data_source/remote/auth_remote_data_source.dart';
import 'package:injectable/injectable.dart';
import '../../../../config/error_handling/result.dart';
import '../../domain/repositories/auth_repo.dart';
import '../models/responses/enter_email_response.dart';
import '../models/responses/new_password_response.dart';
import '../models/responses/verify_otp_response.dart';

@Injectable(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource _authRemoteDataSource;

  const AuthRepoImpl(this._authRemoteDataSource);

  @override
  Future<Result<bool>> enterEmail({required String email}) async {
    final response = await _authRemoteDataSource.enterEmail(email: email);

    switch (response) {
      case Success<EnterEmailResponse>():
        {
          return Success(data: true);
        }
      case Failure<EnterEmailResponse>():
        {
          return Failure(errorMessage: response.errorMessage);
        }
    }
  }

  @override
  Future<Result<bool>> verifyOtp({required String otp}) async {
    final response = await _authRemoteDataSource.verifyOtp(otp: otp);

    switch (response) {
      case Success<VerifyOtpResponse>():
        {
          return Success(data: true);
        }
      case Failure<VerifyOtpResponse>():
        {
          return Failure(errorMessage: response.errorMessage);
        }
    }
  }

  @override
  Future<Result<bool>> addNewPassword({
    required String email,
    required String newPassword,
  }) async {
    final response = await _authRemoteDataSource.addNewPassword(
      email: email,
      newPassword: newPassword,
    );

    switch (response) {
      case Success<NewPasswordResponse>():
        {
          return Success(data: true);
        }
      case Failure<NewPasswordResponse>():
        {
          return Failure(errorMessage: response.errorMessage);
        }
    }
  }
}
