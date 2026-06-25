import 'package:flower_driver/core/localization/l10n/app_localizations.dart';
import 'package:flower_driver/core/shared_widgets/custom_button.dart';
import 'package:flower_driver/core/utils/app_colors.dart';
import 'package:flower_driver/features/orders/presentation/widgets/active_order_details/contact_address_card.dart';
import 'package:flower_driver/features/orders/presentation/widgets/active_order_details/order_details_item.dart';
import 'package:flower_driver/features/orders/presentation/widgets/active_order_details/order_details_row_text.dart';
import 'package:flower_driver/features/orders/presentation/widgets/active_order_details/order_details_status_section.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/app_constants.dart';
import '../../../../../core/utils/app_text_styles.dart';
import '../../widgets/active_order_details/order_status_progress_bar.dart';

class ActiveOrderDetailsScreen extends StatefulWidget {
  const ActiveOrderDetailsScreen({super.key});

  @override
  State<ActiveOrderDetailsScreen> createState() =>
      _ActiveOrderDetailsScreenState();
}

class _ActiveOrderDetailsScreenState extends State<ActiveOrderDetailsScreen> {
  late AppLocalizations localizations;

  @override
  void didChangeDependencies() {
    localizations = AppLocalizations.of(context)!;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.orderDetails),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingHorizontal,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    const OrderStatusProgressBar(currentStep: 1),

                    const SizedBox(height: 24),

                    OrderDetailsStatusSection(
                      status: "Accepted",
                      orderId: "12345",
                      orderTime: DateTime.now(),
                    ),

                    const SizedBox(height: 16),
                    Text(
                      localizations.pickupAddress,
                      style: AppTextStyles.medium18(context),
                    ),
                    const SizedBox(height: 16),
                    ContactAddressCard(
                      imageUrl: "",
                      name: "Flower Store",
                      address: "20th st, Sheikh Zayed, Giza",
                      onCallPressed: () {},
                      onWhatsappPressed: () {},
                    ),
                    const SizedBox(height: 16),
                    Text(
                      localizations.userAddress,
                      style: AppTextStyles.medium18(context),
                    ),
                    const SizedBox(height: 16),
                    ContactAddressCard(
                      imageUrl: "",
                      name: "Nour Mohamed",
                      address: "20th st, Sheikh Zayed, Giza",
                      onCallPressed: () {},
                      onWhatsappPressed: () {},
                    ),
                    const SizedBox(height: 16),
                    Text(
                      localizations.orderDetails,
                      style: AppTextStyles.medium18(context),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      children: List.generate(3, (index) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: OrderDetailsItem(
                            imageUrl: "",
                            title: "Red roses,15 Pink Rose Bouquet",
                            price: "600",
                            numberOfItem: 5,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 24),
                    OrderDetailsRowText(
                      title: localizations.total,
                      value: "${localizations.egp} 3000",
                    ),
                    const SizedBox(height: 24),
                    OrderDetailsRowText(
                      title: localizations.paymentMethod,
                      value: "Cash on delivery",
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.black100.withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: CustomButton(
              title: "Arrived at Pickup point",
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
