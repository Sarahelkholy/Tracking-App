import 'package:flower_driver/core/shared_widgets/custom_button.dart';
import 'package:flower_driver/core/utils/app_colors.dart';
import 'package:flower_driver/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.baseWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 2),

              SizedBox(
                width: MediaQuery.of(context).size.height,
                height: MediaQuery.of(context).size.height * 0.4,
                child: OverflowBox(
                  minWidth: MediaQuery.of(context).size.height,
                  maxWidth: MediaQuery.of(context).size.height,
                  child: Center(
                    child: Lottie.asset(
                      'assets/images/onboarding_animation.json',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              const Spacer(flex: 2),

              Text(
                "Welcome to\nFlowery rider app",
                style: AppTextStyles.medium20(context).copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  height: 1.3,
                ),
                textAlign: TextAlign.start,
              ),

              const Spacer(flex: 1),

              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  title: "Login",
                  onPressed: () {
                    // Navigate to Login
                  },
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  title: "Apply now",
                  titleStyle: AppTextStyles.medium16(context).copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                  backgroundColor: AppColors.baseWhite,
                  borderColor: AppColors.primaryColor,
                  onPressed: () {
                    // Navigate to Apply screen
                  },
                ),
              ),

              const Spacer(flex: 3),

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

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
