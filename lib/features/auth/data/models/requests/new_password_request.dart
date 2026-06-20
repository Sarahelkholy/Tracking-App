import 'package:equatable/equatable.dart';

class NewPasswordRequest extends Equatable {
  final String email;
  final String newPassword;

  const NewPasswordRequest({required this.email, required this.newPassword});

  Map<String, dynamic> toJson() {
    return {"email": email, "newPassword": newPassword};
  }

  @override
  List<Object?> get props => [email, newPassword];
}
