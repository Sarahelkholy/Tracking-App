import 'package:flower_driver/core/localization/l10n/app_localizations.dart';
import 'package:flower_driver/core/utils/app_assets.dart';
import 'package:flower_driver/core/utils/app_colors.dart';
import 'package:flower_driver/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class OrderDetailsItem extends StatelessWidget {
  const OrderDetailsItem({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.numberOfItem,
  });

  final String imageUrl;
  final String title;
  final String price;
  final int numberOfItem;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
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
        children: [
          ClipOval(
            child: SizedBox(
              width: 44,
              height: 44,
              child: imageUrl.isNotEmpty
                  ? Image.network(imageUrl, fit: BoxFit.cover)
                  : Image.asset(AppAssets.userTestImage, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.regular13(
                    context,
                  ).copyWith(color: AppColors.grayDark),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.egp,
                      style: AppTextStyles.medium13(
                        context,
                      ).copyWith(color: AppColors.darkBase),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      price,
                      style: AppTextStyles.medium13(
                        context,
                      ).copyWith(color: AppColors.darkBase),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "X",
                style: AppTextStyles.medium13(
                  context,
                ).copyWith(color: AppColors.primaryColor),
              ),
              Text(
                "$numberOfItem",
                style: AppTextStyles.medium13(
                  context,
                ).copyWith(color: AppColors.primaryColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
