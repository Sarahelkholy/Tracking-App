import 'package:flower_driver/config/notification_services/save_user_info_service.dart';
import 'package:flower_driver/features/auth/data/models/responses/apply_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../error_handling/result.dart';
import '../domain/use_cases/get_driver_data_use_case.dart';
import 'driver_events.dart';
import 'driver_state.dart';

@lazySingleton
class DriverCubit extends Cubit<DriverState> {
  DriverCubit(this._getDriverDataUseCase, this.saveUserInfoService)
    : super(DriverState());

  final GetDriverDataUseCase _getDriverDataUseCase;
  final SaveUserInfoService saveUserInfoService;

  bool _handledUnauthorized = false;
  bool _deviceInitialized = false;

  /// events
  void doEvent(DriverEvents event) {
    switch (event) {
      case GetDriverDataEvent():
        {
          _getDriverData();
          break;
        }
      case SetDriverDataEvent():
        {
          emit(state.copyWith(driver: event.driver));
          break;
        }
      case UnauthorizedDriverEvent():
        {
          _handleUnauthorized();
          break;
        }
      case ResetUnauthorizedEvent():
        {
          _resetUnauthorized();
          break;
        }
    }
  }

  Future<void> _getDriverData() async {
    emit(state.copyWith(isLoading: true));
    final response = await _getDriverDataUseCase.call();

    switch (response) {
      case Success():
        final driver = response.data;

        emit(state.copyWith(isLoading: false, driver: driver));
        if (driver != null && !_deviceInitialized) {
          _deviceInitialized = true;
          await saveUserInfoService.initUserDevice(driver.id ?? '');
        }

        break;

      case Failure():
        emit(state.copyWith(isLoading: false, error: response.errorMessage));
        break;
    }
  }

  void _resetUnauthorized() {
    _handledUnauthorized = false;
    emit(state.copyWith(isUnauthorized: false));
  }

  void _handleUnauthorized() {
    if (_handledUnauthorized) return;
    _handledUnauthorized = true;

    emit(state.copyWith(isUnauthorized: true, driver: null));
  }
}
