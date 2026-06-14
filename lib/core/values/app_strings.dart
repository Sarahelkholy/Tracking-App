import '../localization/l10n/app_localizations.dart';

abstract class AppStrings {
  static AppLocalizations? _current;

  static AppLocalizations get current => _current!;

  static set current(AppLocalizations value) {
    _current = value;
  }
}
