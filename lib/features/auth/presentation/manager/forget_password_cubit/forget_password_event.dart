sealed class ForgetPasswordEvents {}

class SendEmailEvent extends ForgetPasswordEvents {
  final String email;

  SendEmailEvent({required this.email});
}

class VerifyOtpEvent extends ForgetPasswordEvents {
  final String otp;

  VerifyOtpEvent({required this.otp});
}

class ResendOtpEvent extends ForgetPasswordEvents {
  final String email;

  ResendOtpEvent({required this.email});
}

class ResetPasswordEvent extends ForgetPasswordEvents {
  final String newPassword;

  ResetPasswordEvent({required this.newPassword});
}
