import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/profile/domain/entities/profile/driver_data_entity.dart';
import 'package:flower_driver/features/profile/domain/repositories/profile_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetDriverDataUsecase {
  final ProfileRepo profileRepo;
  GetDriverDataUsecase({required this.profileRepo});

  Future<Result<ProfileDriverEntity>> execute() async {
    return await profileRepo.getDriverData();
  }
}
