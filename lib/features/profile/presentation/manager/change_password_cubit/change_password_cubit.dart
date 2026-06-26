import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/profile/domain/entities/change_password/change_password_request_entity.dart';
import 'package:flower_driver/features/profile/presentation/manager/change_password_cubit/change_password_state.dart';
import 'package:injectable/injectable.dart';
import '../../../../../config/base_cubit/base_cubit.dart';
import '../../../../../config/base_cubit/base_event.dart';
import '../../../../../config/base_state/base_state.dart';
import '../../../../../config/route_manager/routes.dart';
import '../../../domain/use_case/change_password_use_case.dart';
import 'change_password_event.dart';

@injectable
class ChangePasswordCubit extends BaseCubit<ChangePasswordState, BaseEvent> {
  final ChangePasswordUseCase _changePasswordUseCase;
  ChangePasswordCubit(this._changePasswordUseCase)
    : super(const ChangePasswordState());

  void doEventChangePassword(ChangePasswordEvent event) {
    switch (event) {
      case SubmitChangePasswordEvent():
        _changePassword(
          password: event.password,
          newPassword: event.newPassword,
        );
    }
  }

  Future<void> _changePassword({
    required String password,
    required String newPassword,
  }) async {
    emit(
      state.copyWith(
        changePasswordStateParam: const BaseState(isLoading: true),
      ),
    );

    final result = await _changePasswordUseCase.changePassword(
      password: password,
      newPassword: newPassword,
    );
    switch (result) {
      case Success<ChangePasswordEntity>():
        emit(
          state.copyWith(
            changePasswordStateParam: const BaseState(
              isSuccess: true,
            ),
          ),
        );
        emitEvent(
          DisplaySuccessEvent(
            successMsg: result.data.message??"",
          ),
        );

        emitEvent(
          const NavigationEvent(
            routeName: Routes.loginRoute,
            type: NavigationType.pushReplacementAndRemoveUntil,
          ),
        );

        break;
      case Failure<ChangePasswordEntity>():
        emit(
          state.copyWith(
            changePasswordStateParam: BaseState(
              errorMessage: result.errorMessage,
            ),
          ),
        );
        emitEvent(
          DisplayErrorEvent(
            errorMsg: result.errorMessage,
          ),
        );
        break;
    }
  }
}
