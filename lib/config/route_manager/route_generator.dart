import 'package:flower_driver/config/route_manager/routes.dart';
import 'package:flower_driver/core/helpers/custom_logger.dart';
import 'package:flower_driver/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import '../../core/localization/l10n/app_localizations.dart';
import '../../features/auth/presentation/apply/view/pages/splash/splash_screen.dart';
import '../../features/auth/presentation/apply/view/pages/register/apply_page.dart';
import '../../features/auth/presentation/apply/view/pages/login/login_page.dart';

abstract class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    try {
      switch (settings.name) {
        /// Splash Screen
        case Routes.splashRoute:
          return MaterialPageRoute(builder: (_) => const SplashScreen());

        /// Apply Screen
        case Routes.applyRoute:
          return MaterialPageRoute(builder: (_) => const ApplyPage());

        /// Login Screen
        case Routes.loginRoute:
          return MaterialPageRoute(builder: (_) => const LoginPage());

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
