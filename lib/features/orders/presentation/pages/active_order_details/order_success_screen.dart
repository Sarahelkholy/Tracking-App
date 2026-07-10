import 'package:flower_driver/config/route_manager/routes.dart';
import 'package:flower_driver/core/localization/l10n/app_localizations.dart';
import 'package:flower_driver/core/shared_widgets/custom_button.dart';
import 'package:flower_driver/core/utils/app_colors.dart';
import 'package:flower_driver/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                _buildSuccessIcon(),
                const SizedBox(height: 48),
                Text(
                  local.thankYou,
                  style: AppTextStyles.bold24(
                    context,
                  ).copyWith(color: AppColors.success),
                ),
                const SizedBox(height: 12),
                Text(
                  local.orderDeliveredSuccessfully,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.semiBold20(context),
                ),
                const Spacer(),
                CustomButton(
                  title: local.done,
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      Routes.bottomNavBarRoute,
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.success.withValues(alpha: 0.1),
      ),
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.success.withValues(alpha: 0.2),
        ),
        padding: const EdgeInsets.all(20),
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.success,
          ),
          child: const Icon(Icons.check, color: AppColors.white, size: 40),
        ),
      ),
    );
  }
}
