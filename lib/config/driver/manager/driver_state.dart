import '../domain/entities/driver_entity.dart';

class DriverState {
  final bool isLoading;
  final DriverEntity? driver;
  final String? error;
  final bool isUnauthorized;

  DriverState({
    this.isLoading = false,
    this.driver,
    this.error,
    this.isUnauthorized = false,
  });

  DriverState copyWith({
    bool? isLoading,
    DriverEntity? driver,
    String? error,
    bool? isUnauthorized,
  }) {
    return DriverState(
      isLoading: isLoading ?? this.isLoading,
      driver: driver ?? this.driver,
      error: error,
      isUnauthorized: isUnauthorized ?? false,
    );
  }
}
