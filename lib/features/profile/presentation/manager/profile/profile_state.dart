import 'package:flower_driver/config/driver/domain/entities/driver_entity.dart';
import 'package:flower_driver/features/profile/domain/entities/profile/driver_data_entity.dart';

sealed class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final ProfileDriverEntity driverData;

  const ProfileLoaded({required this.driverData});
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError({required this.message});
}

class EditProfileLoading extends ProfileState {
  const EditProfileLoading();
}

class EditProfileSuccess extends ProfileState {
  final String message;
  final DriverEntity? updatedDriver;

  const EditProfileSuccess({required this.message, this.updatedDriver});
}

class EditProfileError extends ProfileState {
  final String message;

  const EditProfileError({required this.message});
}
