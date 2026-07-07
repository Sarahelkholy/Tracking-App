import 'package:flower_driver/core/utils/app_colors.dart';
import 'package:flower_driver/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class OrderDetailsRowText extends StatelessWidget {
  const OrderDetailsRowText({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.grayDark.withValues(alpha: 0.25),
            blurRadius: 4,
            offset: Offset.zero,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.medium16(context)),
          Text(
            value,
            style: AppTextStyles.medium14(
              context,
            ).copyWith(color: AppColors.grayDark),
          ),
        ],
      ),
    );
  }
}
