import 'package:dio/dio.dart';
import 'package:flower_driver/config/error_handling/execute_api.dart';
import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/auth/api/auth_api_client.dart';
import 'package:flower_driver/features/auth/data/models/requests/apply_request.dart';
import 'package:flower_driver/features/auth/data/models/responses/apply_response.dart';
import 'package:injectable/injectable.dart';

import '../../../data/data_source/remote/auth_remote_data_source.dart';

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthApiClient _apiClient;

  const AuthRemoteDataSourceImpl(this._apiClient);
  @override
  Future<Result<ApplyResponse>> apply(ApplyRequest applyRequest) {
    return executeApi(() async {
      final licenseFile = await MultipartFile.fromFile(
        applyRequest.vehicleLicense!,
        filename: applyRequest.vehicleLicense!.split('/').last,
      );
      final nidFile = await MultipartFile.fromFile(
        applyRequest.nidImg!,
        filename: applyRequest.nidImg!.split('/').last,
      );

      return _apiClient.apply(
        applyRequest.country ?? '',
        applyRequest.firstName ?? '',
        applyRequest.lastName ?? '',
        applyRequest.vehicleType ?? '',
        applyRequest.vehicleNumber ?? '',
        licenseFile,
        applyRequest.nid ?? '',
        nidFile,
        applyRequest.email ?? '',
        applyRequest.password ?? '',
        applyRequest.rePassword ?? '',
        applyRequest.gender ?? '',
        applyRequest.phone ?? '',
      );
    });
  }
}
