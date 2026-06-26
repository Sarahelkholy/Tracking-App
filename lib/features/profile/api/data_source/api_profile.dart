import 'package:dio/dio.dart';
import 'package:flower_driver/core/values/api_end_points.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../data/models/request/change_password_request.dart';
import '../../data/models/response/change_password_response.dart';
part 'api_profile.g.dart';

@lazySingleton
@RestApi()
abstract class ApiProfile {
  @factoryMethod
  factory ApiProfile(Dio dio) = _ApiProfile;

  ///? Change password
  @PATCH(ApiEndPoints.changePassword)
  Future<ChangePasswordResponse> changePassword(
    @Body() ChangePasswordRequest changePasswordRequest,
  );
  @GET(ApiEndPoints.getDriverData)
  Future<DriverDataResponse> getDriverData();

  @PUT(ApiEndPoints.editProfile)
  Future<EditProfileResponse> editProfile(@Body() EditProfileRequest body);

  @PUT(ApiEndPoints.updateVehicle)
  Future<DriverDataResponse> updateVehicle(
    @Part(name: "id") String id,
    @Body() dynamic body,
  );
}
