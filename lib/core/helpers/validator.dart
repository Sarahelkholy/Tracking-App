import '../values/app_strings.dart';

abstract class Validator {
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.current.emptyField;
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.current.emailRequired;
    }
    final emailRegex = RegExp(
      r"^[A-Za-z0-9.!#$%&'*+/=?^_`{|}~-]+@[A-Za-z0-9-]+\.[A-Za-z]+$",
    );
    if (!emailRegex.hasMatch(value)) {
      return AppStrings.current.emailInvalid;
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.current.passwordRequired;
    }
    if (value.length < 6) {
      return AppStrings.current.passwordTooShort;
    }
    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]',
    );
    if (!passwordRegex.hasMatch(value)) {
      return AppStrings.current.passwordValid;
    }

    return null;
  }

  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.current.confirmPasswordRequired;
    }
    if (value != password) {
      return AppStrings.current.passwordsNotMatch;
    }
    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]',
    );
    if (!passwordRegex.hasMatch(value)) {
      return AppStrings.current.passwordValid;
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.current.phoneRequired;
    }

    value = value.trim();

    // final phoneRegex = RegExp(r'^\d{9}$');
    //
    // if (!phoneRegex.hasMatch(value)) {
    //   return AppStrings.phoneInvalid;
    // }

    return null;
  }
}
