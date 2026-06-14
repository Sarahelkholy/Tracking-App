import '../entities/driver_entity.dart';
import '../../../error_handling/result.dart';

abstract interface class DriverRepo {
  Future<Result<DriverEntity>> getDriverData();
}
