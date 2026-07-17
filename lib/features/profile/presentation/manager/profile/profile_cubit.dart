import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/profile/data/models/response/upload_profile_photo_response.dart';
import 'package:flower_driver/features/profile/domain/entities/profile/driver_data_entity.dart';
import 'package:flower_driver/features/profile/domain/entities/profile/edit_profile_entity.dart';
import 'package:flower_driver/features/profile/domain/use_case/edit_profile_usecase.dart';
import 'package:flower_driver/features/profile/domain/use_case/get_driver_data_usecase.dart';
import 'package:flower_driver/features/profile/domain/use_case/upload_profile_photo_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'profile_intent.dart';
import 'profile_state.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  final GetDriverDataUsecase _getDriverDataUsecase;
  final EditProfileUsecase _editProfileUsecase;
  final UploadProfilePhotoUsecase _uploadPhotoUsecase;
  ProfileCubit(
    this._getDriverDataUsecase,
    this._editProfileUsecase,
    this._uploadPhotoUsecase,
  ) : super(const ProfileInitial());

  void handleIntent(ProfileIntent intent) {
    switch (intent) {
      case UploadProfilePhotoIntent():
        _uploadPhoto(intent);
        break;
      case LoadProfileData():
        _loadProfileData();
        break;
      case SubmitEditProfile():
        _submitEditProfile(intent);
        break;
      case LogoutIntent():
        // Handle logout logically if needed, typically in auth cubit
        break;
    }
  }

  Future<void> _loadProfileData() async {
    emit(const ProfileLoading());

    final result = await _getDriverDataUsecase.execute();

    switch (result) {
      case Success<ProfileDriverEntity>():
        emit(ProfileLoaded(driverData: result.data));
        break;
      case Failure<ProfileDriverEntity>():
        emit(ProfileError(message: result.errorMessage));
        break;
    }
  }

  Future<void> _submitEditProfile(SubmitEditProfile intent) async {
    emit(const EditProfileLoading());

    final result = await _editProfileUsecase.execute(intent.request);

    switch (result) {
      case Success<EditProfileEntity>():
        emit(
          EditProfileSuccess(
            message: result.data.message ?? 'Profile updated successfully',
            updatedDriver: result.data.driver,
          ),
        );
        // Refresh profile data
        _loadProfileData();
        break;
      case Failure<EditProfileEntity>():
        emit(EditProfileError(message: result.errorMessage));
        break;
    }
  }

  Future<void> _uploadPhoto(UploadProfilePhotoIntent intent) async {
    emit(const UploadProfilePhotoLoading());

    final result = await _uploadPhotoUsecase.call(intent.photo);

    switch (result) {
      case Success<UploadProfilePhotoResponse>():
        emit(
          UploadProfilePhotoSuccess(
            message:
                result.data.message ?? 'Profile photo updated successfully',
          ),
        );
        _loadProfileData();
        break;
      case Failure<UploadProfilePhotoResponse>():
        emit(UploadProfilePhotoError(message: result.errorMessage));
        break;
    }
  }
}
