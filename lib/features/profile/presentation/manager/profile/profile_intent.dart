import 'package:flower_driver/features/profile/data/models/request/edit_profile_request.dart';

sealed class ProfileIntent {
  const ProfileIntent();
}

class LoadProfileData extends ProfileIntent {
  const LoadProfileData();
}

class SubmitEditProfile extends ProfileIntent {
  final EditProfileRequest request;

  const SubmitEditProfile(this.request);
}

class LogoutIntent extends ProfileIntent {
  const LogoutIntent();
}
