import 'package:flower_driver/features/auth/data/models/requests/apply_request.dart';

sealed class ApplyIntents {}

// Intent to fetch list of countries from the API
class LoadCountriesIntent extends ApplyIntents {}

class SelectVehicleTypeIntent extends ApplyIntents {
  final String vehicleType;
  SelectVehicleTypeIntent(this.vehicleType);
}

class SelectCountryIntent extends ApplyIntents {
  final String country;
  SelectCountryIntent(this.country);
}

class SelectGenderIntent extends ApplyIntents {
  final String gender;
  SelectGenderIntent(this.gender);
}

enum DocumentType { vehicleLicense, nidImage }

class UploadDocumentIntent extends ApplyIntents {
  final DocumentType docType;
  final String filePath;
  UploadDocumentIntent(this.docType, this.filePath);
}

class SubmitApplyIntent extends ApplyIntents {
  final ApplyRequest request;
  SubmitApplyIntent(this.request);
}
