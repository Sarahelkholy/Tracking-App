import 'dart:async';

import 'package:flower_driver/core/shared_widgets/custom_loading_indicator.dart';
import 'package:flower_driver/core/values/keys_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../../config/route_manager/routes.dart';
import '../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_constants.dart';
import '../../../../../core/utils/app_text_styles.dart';
import '../../manager/forget_password_cubit/forget_password_cubit.dart';
import '../../manager/forget_password_cubit/forget_password_event.dart';
import '../../manager/forget_password_cubit/forget_password_state.dart';
import '../../widgets/forget_password/custom_otp_field.dart';

class PasswordVerifyOtpScreen extends StatefulWidget {
  const PasswordVerifyOtpScreen({super.key});

  @override
  State<PasswordVerifyOtpScreen> createState() =>
      _PasswordVerifyOtpScreenState();
}

class _PasswordVerifyOtpScreenState extends State<PasswordVerifyOtpScreen> {
  late TextEditingController _otpController;
  int _otpFieldKey = 0;
  late final StreamController<ErrorAnimationType> _errorController;
  late AppLocalizations localizations;
  late KeyboardVisibilityController keyboardVisibilityController;
  late final ForgetPasswordCubit _cubit;

  @override
  void initState() {
    _otpController = TextEditingController();

    _errorController = StreamController<ErrorAnimationType>.broadcast();
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
    _otpController.dispose();
    _errorController.close();
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
        if (didPop) return;

        Navigator.popUntil(context, ModalRoute.withName(Routes.loginRoute));
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(localizations.password),
          leading: IconButton(
            onPressed: () {
              Navigator.popUntil(
                context,
                ModalRoute.withName(Routes.loginRoute),
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
                  key: const Key(KeysStrings.verifyOtpTitle),
                  localizations.emailVerification,
                  style: AppTextStyles.medium18(context),
                ),
                const SizedBox(height: 16),
                Text(
                  key: const Key(KeysStrings.verifyOtpSubtitle),
                  localizations.verifyOtpSubTitle,
                  style: AppTextStyles.regular14(
                    context,
                  ).copyWith(color: AppColors.grayDark),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
                  listenWhen: (previous, current) {
                    return previous.verifyOtpState != current.verifyOtpState;
                  },
                  listener: (context, state) {
                    if (state.verifyOtpState.errorMessage != null) {
                      _errorController.add(ErrorAnimationType.shake);

                      Future.delayed(const Duration(seconds: 1), () {
                        if (!mounted) return;

                        setState(() {
                          _otpController.clear();
                          _otpFieldKey++;
                        });
                      });
                    }
                  },
                  buildWhen: (previous, current) {
                    return previous.verifyOtpState != current.verifyOtpState ||
                        previous.sendEmailState != current.sendEmailState;
                  },

                  builder: (context, state) {
                    return CustomOtpField(
                      key: ValueKey(_otpFieldKey),
                      onCompleted: (value) {
                        _cubit.doEvents(VerifyOtpEvent(otp: value));
                      },
                      errorController: _errorController,
                      controller: _otpController,
                      isLoading:
                          state.verifyOtpState.isLoading ||
                          state.sendEmailState.isLoading,
                    );
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      localizations.didNotReceiveCode,
                      style: AppTextStyles.regular16(context),
                    ),
                    const SizedBox(width: 8),
                    BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
                      buildWhen: (previous, current) {
                        return previous.verifyOtpState !=
                                current.verifyOtpState ||
                            previous.sendEmailState != current.sendEmailState ||
                            previous.resendSeconds != current.resendSeconds;
                      },
                      builder: (context, state) {
                        if (state.sendEmailState.isLoading) {
                          return const SizedBox(
                            width: 70,
                            height: 24,
                            child: Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CustomLoadingIndicator(),
                              ),
                            ),
                          );
                        }

                        if (state.resendSeconds > 0) {
                          return Text(
                            key: const Key(KeysStrings.timerText),
                            "00:${state.resendSeconds.toString().padLeft(2, '0')}",
                            style: AppTextStyles.regular16(
                              context,
                            ).copyWith(color: AppColors.primaryColor),
                          );
                        }

                        return GestureDetector(
                          key: const Key(KeysStrings.resendText),
                          onTap: state.verifyOtpState.isLoading
                              ? null
                              : () {
                                  _cubit.doEvents(
                                    ResendOtpEvent(email: state.email!),
                                  );
                                },
                          child: Text(
                            localizations.resend,
                            style: AppTextStyles.regular16(context).copyWith(
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.primaryColor,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
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
