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

  ApplyCubit(this._applyUseCase) : super(ApplyState.initial());

  void handleIntent(ApplyIntents intent) {
    switch (intent) {
      case SelectCountryIntent selectCountryIntent:
        _onSelectCountry(selectCountryIntent);
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
        _onSubmitApply(submitApplyIntent);
        break;
    }
  }

  void _onSelectCountry(SelectCountryIntent intent) {
    emit(state.copyWith(selectedCountry: intent.country));
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
