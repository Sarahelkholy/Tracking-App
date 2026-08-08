import 'package:dio/dio.dart';
import 'package:flower_driver/features/auth/data/models/responses/auth_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../core/values/api_end_points.dart';
import '../../../core/values/api_strings.dart';
import '../data/models/requests/enter_email_request.dart';
import '../data/models/requests/new_password_request.dart';
import '../data/models/requests/verify_otp_request.dart';
import '../data/models/responses/enter_email_response.dart';
import '../data/models/responses/new_password_response.dart';
import '../data/models/responses/verify_otp_response.dart';

import 'package:retrofit/retrofit.dart';
import '../../../core/values/api_end_points.dart';
import '../data/models/requests/login_request.dart';

part 'auth_api_client.g.dart';

@injectable
@RestApi()
abstract class AuthApiClient {
  @factoryMethod
  factory AuthApiClient(Dio dio) = _AuthApiClient;

  @POST(ApiEndPoints.login)
  Future<AuthResponse> signIn(@Body() LoginRequest loginRequest);

  @POST(ApiEndPoints.forgetPassword)
  @Extra({ApiStrings.requireAuth: false})
  Future<EnterEmailResponse> enterEmail(@Body() EnterEmailRequest request);

  @POST(ApiEndPoints.verifyResetCode)
  @Extra({ApiStrings.requireAuth: false})
  Future<VerifyOtpResponse> verifyOtp(@Body() VerifyOtpRequest request);

  @PUT(ApiEndPoints.resetPassword)
  @Extra({ApiStrings.requireAuth: false})
  Future<NewPasswordResponse> addNewPassword(
    @Body() NewPasswordRequest request,
  );
}
