import 'package:dio/dio.dart';
import 'package:flower_driver/core/values/api_end_points.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../data/models/request/change_password_request.dart';
import '../../data/models/response/change_password_response.dart';
part 'api_profile.g.dart';

@injectable
@RestApi()
abstract class ApiProfile {
  @factoryMethod
  factory ApiProfile(Dio dio) = _ApiProfile;

  ///? Change password
  @PATCH(ApiEndPoints.changePassword)
  Future<ChangePasswordResponse> changePassword(
    @Body() ChangePasswordRequest changePasswordRequest,
  );
}
