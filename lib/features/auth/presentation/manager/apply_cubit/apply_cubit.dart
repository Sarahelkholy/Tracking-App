import 'package:flower_driver/features/auth/data/models/responses/country_model.dart';
import 'package:flower_driver/features/auth/domain/use_case/get_all_countries_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import 'package:flower_driver/config/error_handling/result.dart';
import 'package:flower_driver/features/auth/data/models/responses/apply_response.dart';
import 'package:flower_driver/features/auth/domain/use_case/apply_use_case.dart';
import 'apply_intents.dart';

part 'apply_state.dart';

@injectable
class ApplyCubit extends Cubit<ApplyState> {
  final ApplyUseCase _applyUseCase;
  final GetAllCountriesUseCase _getCountriesUseCase;

  ApplyCubit(this._applyUseCase, this._getCountriesUseCase)
    : super(ApplyState.initial());

  Future<void> handleIntent(ApplyIntents intent) async {
    switch (intent) {
      case SelectCountryIntent selectCountryIntent:
        await _onSelectCountry(selectCountryIntent);
        break;
      case SelectVehicleTypeIntent selectVehicleTypeIntent:
        _onSelectVehicleType(selectVehicleTypeIntent);
        break;
      case SelectGenderIntent selectGenderIntent:
        _onSelectGender(selectGenderIntent);
        break;
      case UploadDocumentIntent uploadDocumentIntent:
        _onUploadDocument(uploadDocumentIntent);
        break;
      case SubmitApplyIntent submitApplyIntent:
        await _onSubmitApply(submitApplyIntent);
        break;
    }
  }

  Future<void> _onSelectCountry(SelectCountryIntent intent) async {
    final result = await _getCountriesUseCase();

    switch (result) {
      case Success<List<CountryModel>>():
        final country = result.data.firstWhere(
          (country) => country.name == intent.country,
          orElse: () => CountryModel(name: intent.country),
        );
        emit(state.copyWith(selectedCountry: country.name ?? intent.country));
        break;
      case Failure<List<CountryModel>>():
        emit(state.copyWith(errorMessage: result.errorMessage));
        break;
    }
  }

  void _onSelectVehicleType(SelectVehicleTypeIntent intent) {
    emit(state.copyWith(selectedVehicleType: intent.vehicleType));
  }

  void _onSelectGender(SelectGenderIntent intent) {
    emit(state.copyWith(selectedGender: intent.gender));
  }

  void _onUploadDocument(UploadDocumentIntent intent) {
    if (intent.docType == DocumentType.vehicleLicense) {
      emit(state.copyWith(vehicleLicensePath: intent.filePath));
    } else if (intent.docType == DocumentType.nidImage) {
      emit(state.copyWith(nidImagePath: intent.filePath));
    }
  }

  Future<void> _onSubmitApply(SubmitApplyIntent intent) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
        isSuccess: false,
        clearError: true,
      ),
    );

    final result = await _applyUseCase(intent.request);

    if (isClosed) return;

    switch (result) {
      case Success<ApplyResponse>():
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            message: result.data.message,
            driver: result.data.driver,
            token: result.data.token,
          ),
        );
      case Failure<ApplyResponse>():
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: false,
            errorMessage: result.errorMessage,
          ),
        );
    }
  }
}
