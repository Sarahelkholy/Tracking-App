import '../domain/entities/driver_entity.dart';

sealed class DriverEvents {}

class GetDriverDataEvent extends DriverEvents {}

class SetDriverDataEvent extends DriverEvents {
  final DriverEntity driver;

  SetDriverDataEvent({required this.driver});
}

class UnauthorizedDriverEvent extends DriverEvents {}

class ResetUnauthorizedEvent extends DriverEvents {}
