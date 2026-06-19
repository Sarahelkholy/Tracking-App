import 'package:flower_driver/core/localization/l10n/app_localizations.dart';
import 'package:flower_driver/core/shared_widgets/custom_button.dart';
import 'package:flower_driver/core/utils/app_colors.dart';
import 'package:flower_driver/core/utils/app_text_styles.dart';
import 'package:flower_driver/core/values/keys_strings.dart';
import 'package:flower_driver/features/auth/presentation/manager/forget_password_cubit/forget_password_cubit.dart';
import 'package:flower_driver/features/auth/presentation/manager/forget_password_cubit/forget_password_event.dart';
import 'package:flower_driver/features/auth/presentation/manager/forget_password_cubit/forget_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../../../../../config/base_cubit/base_event.dart';
import '../../../../../config/route_manager/routes.dart';
import '../../../../../core/helpers/app_snack_bar.dart';
import '../../../../../core/helpers/validator.dart';
import '../../../../../core/utils/app_constants.dart';

class PasswordEnterEmailScreen extends StatefulWidget {
  const PasswordEnterEmailScreen({super.key});

  @override
  State<PasswordEnterEmailScreen> createState() =>
      _PasswordEnterEmailScreenState();
}

class _PasswordEnterEmailScreenState extends State<PasswordEnterEmailScreen> {
  late AppLocalizations localizations;
  late KeyboardVisibilityController keyboardVisibilityController;
  late final ForgetPasswordCubit _cubit;
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    keyboardVisibilityController = KeyboardVisibilityController();

    keyboardVisibilityController.onChange.listen((visible) {
      if (!visible) {
        FocusManager.instance.primaryFocus?.unfocus();
      }
    });

    _cubit = context.read<ForgetPasswordCubit>();
    _cubit.eventStream.listen((event) {
      switch (event) {
        case DisplayErrorEvent():
          if (!mounted) return;
          AppSnackBar.error(context, event.errorMsg);

        case DisplaySuccessEvent():
          if (!mounted) return;
          AppSnackBar.success(context, event.successMsg);

        case NavigationEvent():
          if (!mounted) return;
          Navigator.pushNamed(context, event.routeName);
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localizations = AppLocalizations.of(context)!;
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: const Key(KeysStrings.enterEmailAppBar),
        title: Text(localizations.password),
        leading: IconButton(
          key: const Key(KeysStrings.backButton),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.loginRoute,
              (route) => false,
            );
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingHorizontal,
          ),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Text(
                key: const Key(KeysStrings.titleText),
                localizations.forgetPassword,
                style: AppTextStyles.medium18(context),
              ),
              const SizedBox(height: 16),
              Text(
                key: const Key(KeysStrings.subtitleText),
                localizations.enterEmailSubTitle,
                style: AppTextStyles.regular14(
                  context,
                ).copyWith(color: AppColors.grayDark),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
                buildWhen: (previous, current) {
                  return previous.sendEmailState != current.sendEmailState;
                },
                builder: (context, state) {
                  return Form(
                    key: formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        TextFormField(
                          key: const Key(KeysStrings.emailTextField),
                          controller: emailController,
                          enabled: !state.sendEmailState.isLoading,
                          validator: Validator.email,
                          keyboardType: TextInputType.emailAddress,
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          decoration: InputDecoration(
                            labelText: localizations.email,
                            hintText: localizations.enterYourEmail,
                          ),
                        ),
                        const SizedBox(height: 48),
                        CustomButton(
                          key: const Key(KeysStrings.confirmButtonEnterEmail),
                          title: localizations.confirm,
                          isLoading: state.sendEmailState.isLoading,
                          onPressed: () {
                            if (!formKey.currentState!.validate()) {
                              return;
                            }

                            _cubit.doEvents(
                              SendEmailEvent(email: emailController.text),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
