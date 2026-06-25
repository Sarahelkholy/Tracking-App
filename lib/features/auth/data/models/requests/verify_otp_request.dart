import 'package:equatable/equatable.dart';

class VerifyOtpRequest extends Equatable {
  final String resetCode;

  const VerifyOtpRequest({required this.resetCode});

  Map<String, dynamic> toJson() {
    return {"resetCode": resetCode};
  }

  @override
  List<Object?> get props => [resetCode];
}
