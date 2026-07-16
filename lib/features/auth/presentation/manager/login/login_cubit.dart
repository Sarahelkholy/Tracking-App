import 'package:flower_driver/config/driver/domain/entities/driver_entity.dart';
import 'package:flower_driver/config/driver/manager/driver_cubit.dart';
import 'package:flower_driver/config/driver/manager/driver_events.dart';
import 'package:flower_driver/features/auth/data/models/responses/auth_response.dart';
import 'package:flower_driver/features/orders/domain/use_cases/get_active_order_use_case.dart';
import 'package:flower_driver/config/driver/domain/use_cases/get_driver_data_use_case.dart';
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
  final GetDriverDataUseCase _getDriverDataUseCase;
  final GetActiveOrderUseCase _getActiveOrderUseCase;
  final DriverCubit _driverCubit;

  LoginCubit(
    this._loginUseCase,
    this._getDriverDataUseCase,
    this._getActiveOrderUseCase,
    this._driverCubit,
  ) : super(const LoginInitial());

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
        final driverResult = await _getDriverDataUseCase.call();

        switch (driverResult) {
          case Success<DriverEntity>():
            _driverCubit.doEvent(SetDriverDataEvent(driver: driverResult.data));

            final activeOrderResult = await _getActiveOrderUseCase.call(
              driverResult.data.id ?? "",
            );

            bool hasActiveOrder = false;
            if (activeOrderResult is Success) {
              hasActiveOrder = (activeOrderResult as Success).data != null;
            }

            emit(
              LoginSuccess(
                authResponse: result.data,
                rememberMe: event.rememberMe,
                hasActiveOrder: hasActiveOrder,
              ),
            );
          case Failure<DriverEntity>():
            emit(
              LoginFailure(
                errorMessage: driverResult.errorMessage,
                rememberMe: event.rememberMe,
              ),
            );
        }
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
