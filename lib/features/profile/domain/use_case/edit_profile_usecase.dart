import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/profile/data/models/request/edit_profile_request.dart';
import 'package:flower_driver/features/profile/domain/entities/profile/edit_profile_entity.dart';
import 'package:flower_driver/features/profile/domain/repositories/profile_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class EditProfileUsecase {
  final ProfileRepo profileRepo;
  EditProfileUsecase({required this.profileRepo});

  Future<Result<EditProfileEntity>> execute(EditProfileRequest body) async {
    return await profileRepo.editProfile(body);
  }
}
