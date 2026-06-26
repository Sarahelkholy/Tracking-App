import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:flower_driver/core/values/api_end_points.dart';

import 'package:flower_driver/features/auth/data/models/requests/login_request.dart';
import 'package:flower_driver/features/auth/data/models/responses/apply_response.dart';
import 'package:flower_driver/features/auth/data/models/responses/logout_response.dart';
import 'package:flower_driver/features/auth/data/models/responses/auth_response.dart';

import '../../../core/values/api_strings.dart';
import '../data/models/requests/enter_email_request.dart';
import '../data/models/requests/new_password_request.dart';
import '../data/models/requests/verify_otp_request.dart';
import '../data/models/responses/enter_email_response.dart';
import '../data/models/responses/new_password_response.dart';
import '../data/models/responses/verify_otp_response.dart';

part 'auth_api_client.g.dart';

@injectable
@RestApi()
abstract class AuthApiClient {
  @factoryMethod
  factory AuthApiClient(Dio dio) = _AuthApiClient;

  // Apply endpoint (multipart request)
  @POST(ApiEndPoints.apply)
  @MultiPart()
  Future<ApplyResponse> apply({
    @Part(name: "country") required String country,
    @Part(name: "firstName") required String firstName,
    @Part(name: "lastName") required String lastName,
    @Part(name: "vehicleType") required String vehicleType,
    @Part(name: "vehicleNumber") required String vehicleNumber,
    @Part(name: "vehicleLicense") required MultipartFile vehicleLicense,
    @Part(name: "NID") required String nid,
    @Part(name: "NIDImg") required MultipartFile nidImg,
    @Part(name: "email") required String email,
    @Part(name: "password") required String password,
    @Part(name: "rePassword") required String rePassword,
    @Part(name: "gender") required String gender,
    @Part(name: "phone") required String phone,
  });

  // Logout endpoint
  @GET(ApiEndPoints.logout)
  Future<LogoutResponse> logout();

  // Sign-in endpoint
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
