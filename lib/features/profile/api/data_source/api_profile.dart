import 'dart:core';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flower_driver/core/values/api_end_points.dart';
import 'package:flower_driver/features/profile/data/models/request/edit_profile_request.dart';
import 'package:flower_driver/features/profile/data/models/response/driver_data_response.dart';
import 'package:flower_driver/features/profile/data/models/response/edit_profile_response.dart';
import 'package:flower_driver/features/profile/data/models/response/upload_profile_photo_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
part 'api_profile.g.dart';

@injectable
@RestApi()
abstract class ApiProfile {
  @factoryMethod
  factory ApiProfile(Dio dio) = _ApiProfile;

  @PUT(ApiEndPoints.uploadPhoto)
  Future<UploadProfilePhotoResponse> uploadPhoto(
    @Part(name: "photo") File photo,
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
