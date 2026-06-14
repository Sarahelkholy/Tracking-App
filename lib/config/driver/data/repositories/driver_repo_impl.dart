import 'package:injectable/injectable.dart';
import '../../../error_handling/result.dart';
import '../../domain/entities/driver_entity.dart';
import '../../domain/repositories/driver_repo.dart';
import '../data_sources/remote/driver_remote_data_source.dart';
import '../mapper/driver_mapper.dart';
import '../models/responses/get_driver_data_response.dart';

@Injectable(as: DriverRepo)
class DriverRepoImpl implements DriverRepo {
  final DriverRemoteDataSource _userRemoteDataSource;

  DriverRepoImpl(this._userRemoteDataSource);

  @override
  Future<Result<DriverEntity>> getDriverData() async {
    final response = await _userRemoteDataSource.getDriverData();

    switch (response) {
      case Success<GetDriverDataResponse>():
        {
          return Success(data: response.data.driver!.toEntity());
        }
      case Failure<GetDriverDataResponse>():
        {
          return Failure(errorMessage: response.errorMessage);
        }
    }
  }
}
