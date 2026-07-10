import 'package:flower_driver/core/localization/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../../../core/shared_widgets/custom_button.dart';
import '../../../../../core/utils/app_colors.dart';

class ThankYouScreen extends StatelessWidget {
  const ThankYouScreen({super.key});

  @override
  Widget build(BuildContext context) {
    late AppLocalizations localizations;
    localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.success.withValues(alpha: 0.1),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.success.withValues(alpha: 0.2),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.success.withValues(alpha: 0.4),
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: AppColors.white,
                        size: 48,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                localizations.thankYou,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.success,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                localizations.theOrderDeliveredSuccessfully,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.black90,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
              ),
              const Spacer(flex: 3),
              CustomButton(
                title: localizations.done,
                backgroundColor: AppColors.primaryColor,
                foregroundColor: AppColors.white,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
