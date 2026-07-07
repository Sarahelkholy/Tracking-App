import 'package:flower_driver/core/localization/l10n/app_localizations.dart';
import 'package:flower_driver/core/utils/app_colors.dart';
import 'package:flower_driver/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderDetailsStatusSection extends StatelessWidget {
  const OrderDetailsStatusSection({
    super.key,
    required this.status,
    required this.orderId,
    required this.orderTime,
  });

  final String status;
  final String orderId;
  final DateTime orderTime;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightPink,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                localization.status,
                style: AppTextStyles.semiBold16(
                  context,
                ).copyWith(color: AppColors.success),
              ),
              const SizedBox(width: 4),
              Text(
                status,
                style: AppTextStyles.semiBold16(
                  context,
                ).copyWith(color: AppColors.success),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                localization.orderId,
                style: AppTextStyles.semiBold16(context),
              ),
              const SizedBox(width: 4),
              Text(orderId, style: AppTextStyles.semiBold16(context)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            DateFormat('EEE, dd MMM yyyy, hh:mm a').format(orderTime),
            style: AppTextStyles.medium14(
              context,
            ).copyWith(color: AppColors.grayDark),
          ),
        ],
      ),
    );
  }
}
