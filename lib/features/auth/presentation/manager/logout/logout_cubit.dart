import 'package:equatable/equatable.dart';
import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/auth/domain/entities/logout_response_entity.dart';
import 'package:flower_driver/features/auth/domain/use_case/logout_use_case.dart';
import 'package:flower_driver/features/auth/presentation/manager/logout/logout_events.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'logout_state.dart';

@injectable
class LogoutCubit extends Cubit<LogoutState> {
  final LogoutUseCase _logoutUseCase;

  LogoutCubit(this._logoutUseCase) : super(LogoutInitial());

  void doEvents(LogoutEvents event) {
    switch (event) {
      case LogoutEvent():
        _logout();
        break;
    }
  }

  Future<void> _logout() async {
    emit(LogoutLoading());
    final result = await _logoutUseCase.call();

    switch (result) {
      case Success<LogoutResponseEntity>():
        emit(LogoutSuccess(logoutResponseEntity: result.data));
        break;
      case Failure<LogoutResponseEntity>():
        emit(LogoutFailure(errorMessage: result.errorMessage));
        break;
    }
  }
}
