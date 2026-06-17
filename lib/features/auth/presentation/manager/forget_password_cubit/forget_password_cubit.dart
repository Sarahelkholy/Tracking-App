import 'package:flower_driver/config/base_cubit/base_cubit.dart';
import 'package:flower_driver/config/base_cubit/base_event.dart';
import 'package:flower_driver/config/base_state/base_state.dart';
import 'package:flower_driver/features/auth/domain/use_case/add_new_password_use_case.dart';
import 'package:flower_driver/features/auth/domain/use_case/enter_email_use_case.dart';
import 'package:flower_driver/features/auth/domain/use_case/verify_otp_use_case.dart';
import 'package:flower_driver/features/auth/presentation/manager/forget_password_cubit/forget_password_event.dart';
import 'package:flower_driver/features/auth/presentation/manager/forget_password_cubit/forget_password_state.dart';
import 'package:injectable/injectable.dart';

import '../../../../../config/error_handling/result.dart';
import '../../../../../config/route_manager/routes.dart';

@injectable
class ForgetPasswordCubit extends BaseCubit<ForgetPasswordState, BaseEvent> {
  ForgetPasswordCubit(
    this._enterEmailUseCase,
    this._verifyOtpUseCase,
    this._addNewPasswordUseCase,
  ) : super(const ForgetPasswordState());

  final EnterEmailUseCase _enterEmailUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final AddNewPasswordUseCase _addNewPasswordUseCase;

  void doEvents(ForgetPasswordEvents event) {
    switch (event) {
      case SendEmailEvent():
        _enterEmail(event);

      case VerifyOtpEvent():
        _verifyOtp(event);

      case ResetPasswordEvent():
        _resetPassword(event);
    }
  }

  Future<void> _enterEmail(SendEmailEvent event) async {
    emit(
      state.copyWith(
        sendEmailStateParam: const BaseState(isLoading: true),
        emailParam: event.email,
      ),
    );

    final result = await _enterEmailUseCase.call(email: event.email);

    switch (result) {
      case Success():
        emit(
          state.copyWith(sendEmailStateParam: const BaseState(isSuccess: true)),
        );
        emitEvent(
          const NavigationEvent(routeName: Routes.passwordVerifyOtpRoute),
        );

      case Failure():
        emit(
          state.copyWith(
            sendEmailStateParam: BaseState(errorMessage: result.errorMessage),
          ),
        );
        emitEvent(DisplayErrorEvent(errorMsg: result.errorMessage));
    }
  }

  Future<void> _verifyOtp(VerifyOtpEvent event) async {
    emit(state.copyWith(verifyOtpStateParam: const BaseState(isLoading: true)));

    final result = await _verifyOtpUseCase.call(otp: event.otp);

    switch (result) {
      case Success():
        emit(
          state.copyWith(verifyOtpStateParam: const BaseState(isSuccess: true)),
        );
        emitEvent(const NavigationEvent(routeName: Routes.resetPasswordRoute));

      case Failure():
        emit(
          state.copyWith(
            verifyOtpStateParam: BaseState(errorMessage: result.errorMessage),
          ),
        );
        emitEvent(DisplayErrorEvent(errorMsg: result.errorMessage));
    }
  }

  Future<void> _resetPassword(ResetPasswordEvent event) async {
    emit(
      state.copyWith(resetPasswordStateParam: const BaseState(isLoading: true)),
    );

    final result = await _addNewPasswordUseCase.call(
      email: state.email!,
      newPassword: event.newPassword,
    );

    switch (result) {
      case Success():
        emit(
          state.copyWith(
            resetPasswordStateParam: const BaseState(isSuccess: true),
          ),
        );
        emitEvent(
          const DisplaySuccessEvent(
            successMsg: "Password Changed Successfully",
          ),
        );
        emitEvent(const NavigationEvent(routeName: Routes.loginRoute));

      case Failure():
        emit(
          state.copyWith(
            resetPasswordStateParam: BaseState(
              errorMessage: result.errorMessage,
            ),
          ),
        );
        emitEvent(DisplayErrorEvent(errorMsg: result.errorMessage));
    }
  }
}
