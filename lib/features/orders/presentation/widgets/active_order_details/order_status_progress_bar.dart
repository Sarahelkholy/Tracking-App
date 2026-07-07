import 'package:flower_driver/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class OrderStatusProgressBar extends StatelessWidget {
  final int currentStep;

  const OrderStatusProgressBar({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        5,
        (index) => Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 6,
            decoration: BoxDecoration(
              color: index < currentStep
                  ? AppColors.success
                  : AppColors.textHint,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
