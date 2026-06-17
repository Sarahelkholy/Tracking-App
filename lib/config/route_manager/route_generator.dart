import 'package:flower_driver/config/route_manager/routes.dart';
import 'package:flower_driver/core/helpers/custom_logger.dart';
import 'package:flower_driver/core/shared_widgets/custom_bottom_nav.dart';
import 'package:flower_driver/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import '../../core/localization/l10n/app_localizations.dart';
import '../../features/auth/presentation/pages/splash/splash_screen.dart';

abstract class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    try {
      switch (settings.name) {
        /// Splash Screen
        case Routes.splashRoute:
          return MaterialPageRoute(builder: (_) => const SplashScreen());

        case Routes.bottomNavBarRoute:
          final args = settings.arguments as Map<String, dynamic>?;

          return MaterialPageRoute(
            builder: (_) =>
                CustomBottomNavBar(initialIndex: args?['initialIndex'] ?? 0),
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
