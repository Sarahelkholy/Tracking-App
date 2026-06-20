part of 'apply_cubit.dart';

class ApplyState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final String? message;
  final Driver? driver;
  final String? token;

  // Form selections and file paths
  final String selectedCountry;
  final String selectedVehicleType;
  final String selectedGender;
  final String? vehicleLicensePath;
  final String? nidImagePath;

  const ApplyState({
    required this.isLoading,
    required this.isSuccess,
    this.errorMessage,
    this.message,
    this.driver,
    this.token,
    required this.selectedCountry,
    required this.selectedVehicleType,
    required this.selectedGender,
    this.vehicleLicensePath,
    this.nidImagePath,
  });

  factory ApplyState.initial() {
    return const ApplyState(
      isLoading: false,
      isSuccess: false,
      selectedCountry: 'Egypt',
      selectedVehicleType: 'Car',
      selectedGender: 'Male',
    );
  }

  ApplyState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    String? message,
    Driver? driver,
    String? token,
    String? selectedCountry,
    String? selectedVehicleType,
    String? selectedGender,
    String? vehicleLicensePath,
    String? nidImagePath,
    bool clearError = false,
  }) {
    return ApplyState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      message: message ?? this.message,
      driver: driver ?? this.driver,
      token: token ?? this.token,
      selectedCountry: selectedCountry ?? this.selectedCountry,
      selectedVehicleType: selectedVehicleType ?? this.selectedVehicleType,
      selectedGender: selectedGender ?? this.selectedGender,
      vehicleLicensePath: vehicleLicensePath ?? this.vehicleLicensePath,
      nidImagePath: nidImagePath ?? this.nidImagePath,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isSuccess,
        errorMessage,
        message,
        driver,
        token,
        selectedCountry,
        selectedVehicleType,
        selectedGender,
        vehicleLicensePath,
        nidImagePath,
      ];
}
