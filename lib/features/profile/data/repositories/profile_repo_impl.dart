import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/profile/data/data_source/remote/profile_remote_data_source.dart';
import 'package:flower_driver/features/profile/data/models/response/change_password_response.dart';
import 'package:flower_driver/features/profile/domain/entities/change_password/change_password_request_entity.dart';
import 'package:flower_driver/features/profile/domain/repositories/profile_repo.dart';
import 'package:injectable/injectable.dart';
import '../../../../config/cache/secure_cache/secure_cache_helper.dart';
import '../../../../config/secure_cache/secure_cache/cache_keys.dart';
import '../../domain/entities/profile/driver_data_entity.dart';
import '../../domain/entities/profile/edit_profile_entity.dart';
import '../mapper/change_password_response_mapper.dart';
import '../models/request/edit_profile_request.dart';
import '../models/response/driver_data_response.dart';
import '../models/response/edit_profile_response.dart';

@Injectable(as: ProfileRepo)
class ProfileRepoImpl implements ProfileRepo {
  final ProfileRemoteDataSource _dataSource;
  ProfileRepoImpl(this._dataSource);
  @override
  Future<Result<ChangePasswordEntity>> changePassword({
    required String password,
    required String newPassword,
  }) async {
    final response = await _dataSource.changePassword(
      password: password,
      newPassword: newPassword,
    );
    switch (response) {
      case Success<ChangePasswordResponse>():
        final entity = response.data.toEntity();
        if (entity.token != null && entity.token!.isNotEmpty) {
          await SecureCacheHelper.saveData(
            key: CacheKeys.token,
            value: entity.token!,
          );
        }

        return Success(data: entity);

      case Failure<ChangePasswordResponse>():
        return Failure(errorMessage: response.errorMessage);
    }
  }

  @override
  Future<Result<ProfileDriverEntity>> getDriverData() async {
    final result = await _dataSource.getDriverData();

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
    final result = await _dataSource.editProfile(body);
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
    final result = await _dataSource.updateVehicle(id, body);
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
