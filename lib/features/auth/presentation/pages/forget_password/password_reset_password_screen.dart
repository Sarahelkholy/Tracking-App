import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../../../../../config/route_manager/routes.dart';
import '../../../../../core/helpers/validator.dart';
import '../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../core/shared_widgets/custom_button.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_constants.dart';
import '../../../../../core/utils/app_text_styles.dart';
import '../../manager/forget_password_cubit/forget_password_cubit.dart';
import '../../manager/forget_password_cubit/forget_password_event.dart';
import '../../manager/forget_password_cubit/forget_password_state.dart';

class PasswordResetPasswordScreen extends StatefulWidget {
  const PasswordResetPasswordScreen({super.key});

  @override
  State<PasswordResetPasswordScreen> createState() =>
      _PasswordResetPasswordScreenState();
}

class _PasswordResetPasswordScreenState
    extends State<PasswordResetPasswordScreen> {
  late AppLocalizations localizations;
  late KeyboardVisibilityController keyboardVisibilityController;
  late final ForgetPasswordCubit _cubit;
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final newPasswordFocus = FocusNode();
  final confirmPasswordFocus = FocusNode();

  bool isPasswordHidden = true;
  bool isConfirmPasswordHidden = true;

  @override
  void initState() {
    keyboardVisibilityController = KeyboardVisibilityController();

    keyboardVisibilityController.onChange.listen((visible) {
      if (!visible) {
        FocusManager.instance.primaryFocus?.unfocus();
      }
    });

    _cubit = context.read<ForgetPasswordCubit>();
    super.initState();
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();

    newPasswordFocus.dispose();
    confirmPasswordFocus.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localizations = AppLocalizations.of(context)!;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.loginRoute,
          (route) => false,
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(localizations.password),
          leading: IconButton(
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
                  localizations.resetPassword,
                  style: AppTextStyles.medium18(context),
                ),
                const SizedBox(height: 16),
                Text(
                  localizations.resetPasswordSubTitle,
                  style: AppTextStyles.regular14(
                    context,
                  ).copyWith(color: AppColors.grayDark),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
                  buildWhen: (previous, current) {
                    return previous.resetPasswordState !=
                        current.resetPasswordState;
                  },
                  builder: (context, state) {
                    return Form(
                      key: formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: newPasswordController,
                            obscureText: isPasswordHidden,
                            enabled: !state.resetPasswordState.isLoading,
                            validator: Validator.password,
                            keyboardType: TextInputType.visiblePassword,
                            focusNode: newPasswordFocus,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              FocusScope.of(
                                context,
                              ).requestFocus(confirmPasswordFocus);
                            },
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            decoration: InputDecoration(
                              labelText: localizations.newPassword,
                              hintText: localizations.enterYourPassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isPasswordHidden
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: AppColors.grayDark,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isPasswordHidden = !isPasswordHidden;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: confirmPasswordController,
                            obscureText: isConfirmPasswordHidden,
                            enabled: !state.resetPasswordState.isLoading,
                            validator: (value) => Validator.confirmPassword(
                              value,
                              newPasswordController.text,
                            ),
                            keyboardType: TextInputType.visiblePassword,
                            focusNode: confirmPasswordFocus,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).unfocus();
                            },
                            decoration: InputDecoration(
                              labelText: localizations.confirmPassword,
                              hintText: localizations.enterConfirmPassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isConfirmPasswordHidden
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: AppColors.grayDark,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isConfirmPasswordHidden =
                                        !isConfirmPasswordHidden;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 48),
                          CustomButton(
                            title: localizations.confirm,
                            isLoading: state.resetPasswordState.isLoading,
                            onPressed: () {
                              if (!formKey.currentState!.validate()) {
                                return;
                              }

                              _cubit.doEvents(
                                ResetPasswordEvent(
                                  newPassword: newPasswordController.text,
                                  email: state.email!,
                                ),
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
      ),
    );
  }
}
