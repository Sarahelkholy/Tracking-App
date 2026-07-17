import 'package:flutter/material.dart';
import '../../config/route_manager/routes.dart';
import '../localization/l10n/app_localizations.dart';
import '../utils/app_constants.dart';
import 'custom_button.dart';

class SessionExpiredDialog extends StatelessWidget {
  const SessionExpiredDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(localizations.sessionExpired),
      content: Text(localizations.pleaseLoginAgain),
      actions: [
        CustomButton(
          onPressed: () {
            AppConstants.navigatorKey.currentState!.pushNamedAndRemoveUntil(
              Routes.loginRoute,
              (route) => false,
            );
          },
          title: localizations.login,
        ),
      ],
    );
  }
}
