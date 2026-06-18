import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/auth/data/models/requests/apply_request.dart';
import 'package:flower_driver/features/auth/data/models/responses/apply_response.dart';

abstract interface class AuthRepo {
  Future<Result<ApplyResponse>> apply(ApplyRequest applyRequest);
}
