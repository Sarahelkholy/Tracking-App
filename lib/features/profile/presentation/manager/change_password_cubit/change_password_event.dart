import 'package:equatable/equatable.dart';

sealed class ChangePasswordEvent extends Equatable {}

class SubmitChangePasswordEvent extends ChangePasswordEvent {
  final String password;
  final String newPassword;

  SubmitChangePasswordEvent({
    required this.newPassword,
    required this.password,
  });

  @override
  List<Object?> get props => [password, newPassword];
}
