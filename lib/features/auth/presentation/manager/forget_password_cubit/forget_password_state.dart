import 'package:equatable/equatable.dart';

import '../../../../../config/base_state/base_state.dart';

class ForgetPasswordState extends Equatable {
  final BaseState<void> sendEmailState;
  final BaseState<void> verifyOtpState;
  final BaseState<void> resetPasswordState;
  final int resendSeconds;

  final String? email;

  const ForgetPasswordState({
    this.sendEmailState = const BaseState(),
    this.verifyOtpState = const BaseState(),
    this.resetPasswordState = const BaseState(),
    this.resendSeconds = 0,
    this.email,
  });

  ForgetPasswordState copyWith({
    BaseState<void>? sendEmailStateParam,
    BaseState<void>? verifyOtpStateParam,
    BaseState<void>? resetPasswordStateParam,
    int? resendSecondsParam,
    String? emailParam,
  }) {
    return ForgetPasswordState(
      sendEmailState: sendEmailStateParam ?? sendEmailState,
      verifyOtpState: verifyOtpStateParam ?? verifyOtpState,
      resetPasswordState: resetPasswordStateParam ?? resetPasswordState,
      resendSeconds: resendSecondsParam ?? resendSeconds,
      email: emailParam ?? email,
    );
  }

  @override
  List<Object?> get props => [
    sendEmailState,
    verifyOtpState,
    resetPasswordState,
    resendSeconds,
    email,
  ];
}
