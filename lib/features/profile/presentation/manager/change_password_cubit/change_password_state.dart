import 'package:equatable/equatable.dart';
import 'package:flower_driver/features/profile/domain/entities/change_password/change_password_request_entity.dart';
import '../../../../../config/base_state/base_state.dart';

class ChangePasswordState extends Equatable {
  final BaseState<ChangePasswordEntity> changeOldPasswordState;
  const ChangePasswordState({this.changeOldPasswordState = const BaseState()});
  ChangePasswordState copyWith({
    BaseState<ChangePasswordEntity>? changePasswordStateParam,
  }) {
    return ChangePasswordState(
      changeOldPasswordState:
          changePasswordStateParam ?? changeOldPasswordState,
    );
  }

  @override
  List<Object?> get props => [changeOldPasswordState];
}
