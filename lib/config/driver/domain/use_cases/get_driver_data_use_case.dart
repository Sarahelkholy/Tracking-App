import 'package:injectable/injectable.dart';
import '../entities/driver_entity.dart';
import '../../../error_handling/result.dart';
import '../repositories/driver_repo.dart';

@injectable
class GetDriverDataUseCase {
  final DriverRepo _repo;

  const GetDriverDataUseCase(this._repo);

  Future<Result<DriverEntity>> call() {
    return _repo.getDriverData();
  }
}
