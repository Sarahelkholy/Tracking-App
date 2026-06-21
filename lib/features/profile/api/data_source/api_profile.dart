import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
part 'api_profile.g.dart';

@injectable
@RestApi()
abstract class ApiProfile {
  @factoryMethod
  factory ApiProfile(Dio dio) = _ApiProfile;


}
