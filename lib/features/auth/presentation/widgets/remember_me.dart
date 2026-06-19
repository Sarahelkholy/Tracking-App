
import 'package:flutter/material.dart';

import '../../../../config/route_manager/routes.dart';
import '../../../../core/localization/l10n/app_localizations.dart';
import '../../../../core/utils/app_colors.dart';
import '../manager/login/login_cubit.dart';
import '../manager/login/login_event.dart';

class RememberMe extends StatelessWidget {
  const RememberMe({
    super.key,
    required this.rememberMe,
    required this.cubit,
    required this.local,
  });

  final bool rememberMe;
  final LoginCubit cubit;
  final AppLocalizations local;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: rememberMe,
              onChanged: (value) {
                cubit.doEvents(
                  LoginRememberMeChangedEvent(rememberMe: value ?? false),
                );
              },
            ),
            Text(local.rememberMe),
          ],
        ),
        TextButton(
          onPressed: () {
         /*   Navigator.pushNamed(
              context,
              Routes.forgetPasswordEnterEmailViewRoute,
            );*/
          },
          child: Text(
            local.forgetPassword,
            style: const TextStyle(
              decoration: TextDecoration.underline,
              color: AppColors.darkBase,
            ),
          ),
        ),
      ],
    );
  }
}
