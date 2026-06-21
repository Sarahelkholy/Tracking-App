import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/auth/data/models/responses/country_model.dart';
import 'package:flower_driver/features/auth/domain/repositories/auth_repo.dart';

class GetAllCountriesUseCase {
  final AuthRepo _authRepo;

  GetAllCountriesUseCase(this._authRepo);

  Future<Result<List<CountryModel>>> call() {
    return _authRepo.getCountries();
  }
}
