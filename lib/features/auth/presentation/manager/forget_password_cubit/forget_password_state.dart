import 'package:equatable/equatable.dart';

import '../../../../../config/base_state/base_state.dart';

class ForgetPasswordState extends Equatable {
  final BaseState<void> sendEmailState;
  final BaseState<void> verifyOtpState;
  final BaseState<void> resetPasswordState;

  final String? email;

  const ForgetPasswordState({
    this.sendEmailState = const BaseState(),
    this.verifyOtpState = const BaseState(),
    this.resetPasswordState = const BaseState(),
    this.email,
  });

  ForgetPasswordState copyWith({
    BaseState<void>? sendEmailStateParam,
    BaseState<void>? verifyOtpStateParam,
    BaseState<void>? resetPasswordStateParam,
    String? emailParam,
  }) {
    return ForgetPasswordState(
      sendEmailState: sendEmailStateParam ?? sendEmailState,
      verifyOtpState: verifyOtpStateParam ?? verifyOtpState,
      resetPasswordState: resetPasswordStateParam ?? resetPasswordState,
      email: emailParam ?? email,
    );
  }

  @override
  List<Object?> get props => [
    sendEmailState,
    verifyOtpState,
    resetPasswordState,
    email,
  ];
}
