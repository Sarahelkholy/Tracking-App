import 'package:flower_driver/config/di/di.dart';
import 'package:flower_driver/config/driver/manager/driver_cubit.dart';
import 'package:flower_driver/core/helpers/event_handler_mixin.dart';
import 'package:flower_driver/core/helpers/url_launcher_helper.dart';
import 'package:flower_driver/core/localization/l10n/app_localizations.dart';
import 'package:flower_driver/core/shared_widgets/custom_button.dart';
import 'package:flower_driver/core/shared_widgets/custom_error_widget.dart';
import 'package:flower_driver/core/shared_widgets/custom_loading_indicator.dart';
import 'package:flower_driver/core/utils/app_colors.dart';
import 'package:flower_driver/features/orders/domain/entities/enums/order_status_enum.dart';
import 'package:flower_driver/features/orders/domain/entities/order_entity.dart';
import 'package:flower_driver/features/orders/presentation/manager/active_order_cubit/active_order_cubit.dart';
import 'package:flower_driver/features/orders/presentation/manager/active_order_cubit/active_order_event.dart';
import 'package:flower_driver/features/orders/presentation/manager/active_order_cubit/active_order_state.dart';
import 'package:flower_driver/features/orders/presentation/widgets/active_order_details/contact_address_card.dart';
import 'package:flower_driver/features/orders/presentation/widgets/active_order_details/order_details_item.dart';
import 'package:flower_driver/features/orders/presentation/widgets/active_order_details/order_details_row_text.dart';
import 'package:flower_driver/features/orders/presentation/widgets/active_order_details/order_details_status_section.dart';
import 'package:flower_driver/features/orders/presentation/widgets/active_order_details/order_status_extension.dart';
import 'package:flower_driver/core/values/keys_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/app_constants.dart';
import '../../../../../core/utils/app_text_styles.dart';
import '../../widgets/active_order_details/order_status_progress_bar.dart';

class ActiveOrderDetailsScreen extends StatefulWidget {
  const ActiveOrderDetailsScreen({super.key});

  @override
  State<ActiveOrderDetailsScreen> createState() =>
      _ActiveOrderDetailsScreenState();
}

class _ActiveOrderDetailsScreenState extends State<ActiveOrderDetailsScreen>
    with EventHandlerMixin<ActiveOrderDetailsScreen> {
  late AppLocalizations localizations;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<ActiveOrderCubit>();
    cubit.eventStream.listen((event) {
      if (!mounted) return;
      handleEvent(event);
    });
    final driverId = context.read<DriverCubit>().state.driver?.id;
    cubit.doEvents(GetActiveOrderEvent(driverId: driverId ?? ""));
  }

  @override
  void didChangeDependencies() {
    localizations = AppLocalizations.of(context)!;
    super.didChangeDependencies();
  }

  void _onButtonPressed(BuildContext context, OrderEntity order) {
    final cubit = context.read<ActiveOrderCubit>();
    final nextStatus = order.orderStatus.nextStatus;
    if (nextStatus != null) {
      cubit.doEvents(
        UpdateOrderStatusEvent(
          order: order,
          status: nextStatus,
          isActive: order.orderStatus.isActiveNext,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          key: const Key(KeysStrings.activeOrderAppBar),
          titleSpacing: 16,
          automaticallyImplyLeading: false,
          title: Text(localizations.orderDetails),
        ),
        body: BlocBuilder<ActiveOrderCubit, ActiveOrderState>(
          buildWhen: (previous, current) =>
              previous.getActiveOrderState.isLoading !=
                  current.getActiveOrderState.isLoading ||
              (previous.order == null && current.order != null),
          builder: (context, state) {
            if (state.getActiveOrderState.isLoading) {
              return const CustomLoadingIndicator();
            }

            final order = state.order;

            if (order == null) {
              return CustomErrorWidget(
                errorMessage: localizations.noActiveOrderFound,
              );
            }

            return Column(
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
                          BlocBuilder<ActiveOrderCubit, ActiveOrderState>(
                            buildWhen: (p, c) =>
                                p.order?.orderStatus != c.order?.orderStatus,
                            builder: (context, state) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  OrderStatusProgressBar(
                                    key: const Key(
                                      KeysStrings.activeOrderProgressBar,
                                    ),
                                    currentStep: state.order!.orderStatus.step,
                                  ),
                                  const SizedBox(height: 24),
                                  OrderDetailsStatusSection(
                                    key: const Key(
                                      KeysStrings.activeOrderDetailsStatus,
                                    ),
                                    status: state.order!.orderStatus.localized(
                                      localizations,
                                    ),
                                    orderId: state.order!.orderNumber,
                                    orderTime: state.order!.createdAt,
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          Text(
                            localizations.pickupAddress,
                            style: AppTextStyles.medium18(context),
                          ),
                          const SizedBox(height: 16),
                          ContactAddressCard(
                            key: const Key(
                              KeysStrings.activeOrderPickupAddress,
                            ),
                            imageUrl: order.store.image,
                            name: order.store.name,
                            address: order.store.address,
                            onCallPressed: () {
                              getIt<UrlLauncherHelper>().callPhone(
                                order.store.phoneNumber,
                              );
                            },
                            onWhatsappPressed: () {
                              getIt<UrlLauncherHelper>().launchWhatsApp(
                                order.store.phoneNumber,
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          Text(
                            localizations.userAddress,
                            style: AppTextStyles.medium18(context),
                          ),
                          const SizedBox(height: 16),
                          ContactAddressCard(
                            key: const Key(KeysStrings.activeOrderUserAddress),
                            imageUrl: order.user.photo,
                            name:
                                "${order.user.firstName} ${order.user.lastName}",
                            address:
                                "${order.shippingAddress.street}, ${order.shippingAddress.city}",
                            onCallPressed: () {
                              getIt<UrlLauncherHelper>().callPhone(
                                order.user.phone,
                              );
                            },
                            onWhatsappPressed: () {
                              getIt<UrlLauncherHelper>().launchWhatsApp(
                                order.user.phone,
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          Text(
                            localizations.orderDetails,
                            style: AppTextStyles.medium18(context),
                          ),
                          const SizedBox(height: 8),
                          Column(
                            key: const Key(KeysStrings.activeOrderItemsList),
                            children: List.generate(order.orderItems.length, (
                              index,
                            ) {
                              final item = order.orderItems[index];
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: OrderDetailsItem(
                                  imageUrl: item.product.imgCover,
                                  title: item.product.title,
                                  price: item.price.toString(),
                                  numberOfItem: item.quantity.toInt(),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 24),
                          OrderDetailsRowText(
                            key: const Key(KeysStrings.activeOrderTotal),
                            title: localizations.total,
                            value: "${localizations.egp} ${order.totalPrice}",
                          ),
                          const SizedBox(height: 24),
                          OrderDetailsRowText(
                            key: const Key(
                              KeysStrings.activeOrderPaymentMethod,
                            ),
                            title: localizations.paymentMethod,
                            value: order.paymentType,
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
                BlocBuilder<ActiveOrderCubit, ActiveOrderState>(
                  buildWhen: (p, c) =>
                      p.order?.orderStatus != c.order?.orderStatus ||
                      p.updateOrderStatusState.isLoading !=
                          c.updateOrderStatusState.isLoading,
                  builder: (context, state) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 24,
                      ),
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
                        key: const Key(KeysStrings.activeOrderButton),
                        isLoading: state.updateOrderStatusState.isLoading,
                        title: state.order!.orderStatus.buttonTitle(
                          localizations,
                        ),
                        onPressed:
                            state.order!.orderStatus ==
                                OrderStatusEnum.delivered
                            ? null
                            : () => _onButtonPressed(context, state.order!),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
