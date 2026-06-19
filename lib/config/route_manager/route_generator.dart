import 'package:flower_driver/config/route_manager/routes.dart';
import 'package:flower_driver/core/helpers/custom_logger.dart';
import 'package:flower_driver/core/utils/app_text_styles.dart';
import 'package:flower_driver/features/auth/presentation/pages/forget_password/password_enter_email_screen.dart';
import 'package:flower_driver/features/auth/presentation/pages/forget_password/password_reset_password_screen.dart';
import 'package:flower_driver/features/auth/presentation/pages/forget_password/password_verify_otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/localization/l10n/app_localizations.dart';
import '../../features/auth/presentation/manager/forget_password_cubit/forget_password_cubit.dart';
import '../../features/auth/presentation/pages/splash/splash_screen.dart';
import '../di/di.dart';

abstract class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    try {
      switch (settings.name) {
        /// Splash Screen
        case Routes.splashRoute:
          return MaterialPageRoute(builder: (_) => const SplashScreen());

        /// Forget Password - Enter Email
        case Routes.forgetPasswordRoute:
          return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => getIt<ForgetPasswordCubit>(),
              child: const PasswordEnterEmailScreen(),
            ),
          );

        /// OTP View
        case Routes.passwordVerifyOtpRoute:
          final cubit = settings.arguments as ForgetPasswordCubit;

          return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: cubit,
              child: const PasswordVerifyOtpScreen(),
            ),
          );

        /// New Password View
        case Routes.resetPasswordRoute:
          final cubit = settings.arguments as ForgetPasswordCubit;

          return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: cubit,
              child: const PasswordResetPasswordScreen(),
            ),
          );

        /// Default
        default:
          return _errorRoute();
      }
    } catch (e, stackTrace) {
      CustomLogger.bgRed("Route error: $e");
      CustomLogger.bgRed("$stackTrace");

      return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        body: Center(
          child: Text(
            AppLocalizations.of(context)!.pageNotFound,
            style: AppTextStyles.bold20(context),
          ),
        ),
      ),
    );
  }
}
