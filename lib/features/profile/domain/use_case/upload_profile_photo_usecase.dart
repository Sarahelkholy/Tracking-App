import 'dart:io';

import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/profile/data/models/response/upload_profile_photo_response.dart';
import 'package:flower_driver/features/profile/domain/repositories/profile_repo.dart';

class UploadProfilePhotoUsecase {
  final ProfileRepo profileRepo;
  UploadProfilePhotoUsecase(this.profileRepo);

  Future<Result<UploadProfilePhotoResponse>> call(File photo) async {
    return await profileRepo.uploadPhoto(photo);
  }
}
