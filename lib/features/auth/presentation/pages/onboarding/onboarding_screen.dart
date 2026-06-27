import 'package:flower_driver/core/helpers/my_responsive.dart';
import 'package:flower_driver/core/localization/l10n/app_localizations.dart';
import 'package:flower_driver/core/utils/app_assets.dart';
import 'package:flower_driver/core/utils/app_colors.dart';
import 'package:flower_driver/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flower_driver/config/di/di.dart';
import 'package:flower_driver/config/route_manager/routes.dart';
import 'package:flower_driver/config/secure_cache/secure_cache/cache_keys.dart';
import 'package:flower_driver/config/secure_cache/secure_cache/secure_cache.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  Future<void> _completeOnboarding(
    BuildContext context,
    String targetRoute,
  ) async {
    final secureCache = getIt<SecureCache>();
    await secureCache.saveData(key: CacheKeys.hasSeenOnboarding, value: 'true');

    if (!context.mounted) return;
    Navigator.pushReplacementNamed(context, targetRoute);
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: AppColors.baseWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: size.width * .75,
                height: size.height * 0.5,
                child: OverflowBox(
                  minWidth: size.height,
                  maxWidth: size.height,
                  child: Center(
                    child: Lottie.asset(
                      AppAssets.onboardingAnimationImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              Text(
                local.onboardingText,
                style: AppTextStyles.medium20(context),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _completeOnboarding(context, Routes.loginRoute);
                  },
                  child: Text(local.login),
                ),
              ),

              SizedBox(height: MyResponsive.fontSize(context, value: 16)),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.baseWhite,
                    foregroundColor: AppColors.primaryColor,
                    side: const BorderSide(color: AppColors.primaryColor),
                    textStyle: AppTextStyles.medium16(
                      context,
                    ).copyWith(color: AppColors.primaryColor),
                  ),
                  onPressed: () {
                    _completeOnboarding(context, Routes.applyRoute);
                  },
                  child: Text(local.applyNow),
                ),
              ),

              const Spacer(),

              Center(
                child: Text(
                  "v 6.3.0 - (446)",
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
