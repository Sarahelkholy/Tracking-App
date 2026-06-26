import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/profile/data/data_source/remote/profile_remote_data_source.dart';
import 'package:flower_driver/features/profile/data/models/request/edit_profile_request.dart';
import 'package:flower_driver/features/profile/data/models/response/driver_data_response.dart';
import 'package:flower_driver/features/profile/data/models/response/edit_profile_response.dart';
import 'package:flower_driver/features/profile/domain/entities/profile/driver_data_entity.dart';
import 'package:flower_driver/features/profile/domain/entities/profile/edit_profile_entity.dart';
import 'package:flower_driver/features/profile/domain/repositories/profile_repo.dart';

class ProfileRepoImpl implements ProfileRepo {
  final ProfileRemoteDataSource profileRemoteDataSource;
  ProfileRepoImpl({required this.profileRemoteDataSource});
  @override
  Future<Result<ProfileDriverEntity>> getDriverData() async {
    final result = await profileRemoteDataSource.getDriverData();

    switch (result) {
      case Success<DriverDataResponse>():
        return Success(
          data: ProfileDriverEntity(
            message: result.data.message,
            driver: result.data.driver?.toEntity(),
          ),
        );
      case Failure<DriverDataResponse>():
        return Failure(errorMessage: result.errorMessage);
    }
  }

  @override
  Future<Result<EditProfileEntity>> editProfile(EditProfileRequest body) async {
    final result = await profileRemoteDataSource.editProfile(body);
    switch (result) {
      case Success<EditProfileResponse>():
        return Success(
          data: EditProfileEntity(
            message: result.data.message,
            driver: result.data.driver?.toEntity(),
          ),
        );
      case Failure<EditProfileResponse>():
        return Failure(errorMessage: result.errorMessage);
    }
  }

  @override
  Future<Result<ProfileDriverEntity>> updateVehicle(
    String id,
    dynamic body,
  ) async {
    final result = await profileRemoteDataSource.updateVehicle(id, body);
    switch (result) {
      case Success<DriverDataResponse>():
        return Success(
          data: ProfileDriverEntity(
            message: result.data.message,
            driver: result.data.driver?.toEntity(),
          ),
        );
      case Failure<DriverDataResponse>():
        return Failure(errorMessage: result.errorMessage);
    }
  }
}
