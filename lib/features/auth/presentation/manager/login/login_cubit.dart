import 'package:flower_driver/features/auth/data/models/responses/auth_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../config/error_handling/result.dart';
import '../../../data/models/requests/login_request.dart';
import '../../../domain/use_case/login_use_case.dart';
import 'login_event.dart';
import 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;

  LoginCubit(this._loginUseCase) : super(const LoginInitial());

  void doEvents(LoginEvents event) {
    switch (event) {
      case LoginSubmitEvent():
        _login(event);
        break;
      case LoginRememberMeChangedEvent():
        _changeRememberMe(event.rememberMe);
    }
  }

  void _changeRememberMe(bool value) {
    emit(state.copyWith(rememberMe: value));
  }

  Future<void> _login(LoginSubmitEvent event) async {
    emit(LoginLoading(rememberMe: event.rememberMe));

    final result = await _loginUseCase.call(
      LoginRequest(email: event.email, password: event.password),
      event.rememberMe,
    );

    switch (result) {
      case Success<AuthResponse>():
        emit(
          LoginSuccess(authResponse: result.data, rememberMe: event.rememberMe),
        );
        break;

      case Failure<AuthResponse>():
        emit(
          LoginFailure(
            errorMessage: result.errorMessage,
            rememberMe: event.rememberMe,
          ),
        );
        break;
    }
  }
}
