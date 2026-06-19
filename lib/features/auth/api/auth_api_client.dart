import 'package:dio/dio.dart';
import 'package:flower_driver/core/values/api_end_points.dart';
import 'package:flower_driver/features/auth/data/models/responses/apply_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api_client.g.dart';

@injectable
@RestApi()
abstract class AuthApiClient {
  @factoryMethod
  factory AuthApiClient(Dio dio) = _AuthApiClient;

  @POST(ApiEndPoints.apply)
  @MultiPart()
  Future<ApplyResponse> apply(
    @Part(name: "country") String country,
    @Part(name: "firstName") String firstName,
    @Part(name: "lastName") String lastName,
    @Part(name: "vehicleType") String vehicleType,
    @Part(name: "vehicleNumber") String vehicleNumber,
    @Part(name: "vehicleLicense") MultipartFile vehicleLicense,
    @Part(name: "NID") String nid,
    @Part(name: "NIDImg") MultipartFile nidImg,
    @Part(name: "email") String email,
    @Part(name: "password") String password,
    @Part(name: "rePassword") String rePassword,
    @Part(name: "gender") String gender,
    @Part(name: "phone") String phone,
  );
}
