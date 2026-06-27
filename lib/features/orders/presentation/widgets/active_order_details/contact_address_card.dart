import 'package:flower_driver/core/shared_widgets/svg_wrapper.dart';
import 'package:flower_driver/core/utils/app_assets.dart';
import 'package:flower_driver/core/utils/app_colors.dart';
import 'package:flower_driver/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class ContactAddressCard extends StatelessWidget {
  const ContactAddressCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.address,
    this.onCallPressed,
    this.onWhatsappPressed,
  });

  final String imageUrl;
  final String name;
  final String address;
  final VoidCallback? onCallPressed;
  final VoidCallback? onWhatsappPressed;

  @override
  Widget build(BuildContext context) {
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
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.regular13(
                    context,
                  ).copyWith(color: AppColors.grayDark),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: AppColors.darkBase,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        address,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.regular13(
                          context,
                        ).copyWith(color: AppColors.darkBase),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Row(
            children: [
              InkWell(
                onTap: onCallPressed,
                child: const Icon(
                  Icons.call_outlined,
                  size: 20,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: onWhatsappPressed,
                child: const SvgWrapper(
                  path: AppAssets.whatsAppIcon,
                  width: 20,
                  height: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
