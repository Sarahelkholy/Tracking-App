import 'package:equatable/equatable.dart';

class EnterEmailRequest extends Equatable {
  final String email;

  const EnterEmailRequest({required this.email});

  Map<String, dynamic> toJson() {
    return {"email": email};
  }

  @override
  List<Object?> get props => [email];
}
