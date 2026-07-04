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
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  GoogleMapController? _mapController;

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

  LatLng? _parseLatLng(String? latLongStr) {
    if (latLongStr == null || latLongStr.isEmpty) return null;
    final parts = latLongStr.split(',');
    if (parts.length == 2) {
      final lat = double.tryParse(parts[0].trim());
      final lng = double.tryParse(parts[1].trim());
      if (lat != null && lng != null) {
        return LatLng(lat, lng);
      }
    }
    return null;
  }

  LatLng? _parseAddressLatLng(String? lat, String? long) {
    if (lat == null || long == null) return null;
    final latVal = double.tryParse(lat.trim());
    final lngVal = double.tryParse(long.trim());
    if (latVal != null && lngVal != null) {
      return LatLng(latVal, lngVal);
    }
    return null;
  }

  void _onButtonPressed(BuildContext context, OrderEntity order) {
    final cubit = context.read<ActiveOrderCubit>();
    switch (order.orderStatus) {
      case OrderStatusEnum.accepted:
        cubit.doEvents(
          UpdateOrderStatusEvent(
            order: order,
            status: OrderStatusEnum.picked.name,
          ),
        );
      case OrderStatusEnum.picked:
        cubit.doEvents(
          UpdateOrderStatusEvent(
            order: order,
            status: OrderStatusEnum.outForDelivery.name,
          ),
        );
      case OrderStatusEnum.outForDelivery:
        cubit.doEvents(
          UpdateOrderStatusEvent(
            order: order,
            status: OrderStatusEnum.arrived.name,
          ),
        );
      case OrderStatusEnum.arrived:
        cubit.doEvents(
          UpdateOrderStatusEvent(
            order: order,
            status: OrderStatusEnum.delivered.name,
            isActive: false,
          ),
        );
      case OrderStatusEnum.delivered:
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ActiveOrderCubit, ActiveOrderState>(
      listenWhen: (previous, current) {
        final prevLocation = previous.order?.currentLocation;
        final currLocation = current.order?.currentLocation;
        if (prevLocation == null && currLocation != null) return true;
        if (prevLocation != null && currLocation != null) {
          return prevLocation.latitude != currLocation.latitude ||
              prevLocation.longitude != currLocation.longitude;
        }
        return false;
      },
      listener: (context, state) {
        final location = state.order?.currentLocation;
        if (location != null && _mapController != null) {
          _mapController!.animateCamera(
            CameraUpdate.newLatLng(
              LatLng(location.latitude, location.longitude),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.getActiveOrderState.isLoading) {
          return const Scaffold(body: CustomLoadingIndicator());
        }

        final order = state.order;

        if (order == null) {
          return Scaffold(
            appBar: AppBar(
              key: const Key(KeysStrings.activeOrderAppBar),
              title: Text(localizations.orderDetails),
            ),
            body: CustomErrorWidget(
              errorMessage: localizations.noActiveOrderFound,
            ),
          );
        }

        final driverLatLng = order.currentLocation != null
            ? LatLng(
                order.currentLocation!.latitude,
                order.currentLocation!.longitude,
              )
            : null;
        final storeLatLng = _parseLatLng(order.store.latLong);
        final userLatLng = _parseAddressLatLng(
          order.shippingAddress.lat,
          order.shippingAddress.long,
        );

        Set<Marker> markers = {};
        if (driverLatLng != null) {
          markers.add(
            Marker(
              markerId: const MarkerId('driver'),
              position: driverLatLng,
              infoWindow: const InfoWindow(title: 'Driver Location'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueBlue,
              ),
            ),
          );
        }
        if (storeLatLng != null) {
          markers.add(
            Marker(
              markerId: const MarkerId('pickup'),
              position: storeLatLng,
              infoWindow: const InfoWindow(title: 'Pickup Location'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed,
              ),
            ),
          );
        }
        if (userLatLng != null) {
          markers.add(
            Marker(
              markerId: const MarkerId('dropoff'),
              position: userLatLng,
              infoWindow: const InfoWindow(title: 'Dropoff Location'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen,
              ),
            ),
          );
        }

        Set<Polyline> polylines = {};
        if (driverLatLng != null && storeLatLng != null && userLatLng != null) {
          List<LatLng> points = [];
          if (order.orderStatus.step < OrderStatusEnum.picked.step) {
            points = [driverLatLng, storeLatLng];
          } else {
            points = [driverLatLng, userLatLng];
          }
          polylines.add(
            Polyline(
              polylineId: const PolylineId('route'),
              points: points,
              color: AppColors.primaryColor,
              width: 4,
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            key: const Key(KeysStrings.activeOrderAppBar),
            title: Text(localizations.orderDetails),
          ),
          body: Stack(
            fit: StackFit.expand,
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target:
                      driverLatLng ??
                      storeLatLng ??
                      userLatLng ??
                      const LatLng(30.0, 31.0),
                  zoom: 14.0,
                ),
                markers: markers,
                polylines: polylines,
                onMapCreated: (controller) => _mapController = controller,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
              ),
              DraggableScrollableSheet(
                initialChildSize: 0.5,
                minChildSize: 0.15,
                maxChildSize: 0.9,
                builder: (context, scrollController) {
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black100.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.black100.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppConstants.paddingHorizontal,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  OrderStatusProgressBar(
                                    key: const Key(
                                      KeysStrings.activeOrderProgressBar,
                                    ),
                                    currentStep: order.orderStatus.step,
                                  ),
                                  const SizedBox(height: 24),
                                  OrderDetailsStatusSection(
                                    key: const Key(
                                      KeysStrings.activeOrderDetailsStatus,
                                    ),
                                    status: order.orderStatus.localized(
                                      localizations,
                                    ),
                                    orderId: order.orderNumber,
                                    orderTime: order.createdAt,
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
                                      UrlLauncherHelper.callPhone(
                                        order.store.phoneNumber,
                                      );
                                    },
                                    onWhatsappPressed: () {
                                      UrlLauncherHelper.launchWhatsApp(
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
                                    key: const Key(
                                      KeysStrings.activeOrderUserAddress,
                                    ),
                                    imageUrl: order.user.photo,
                                    name:
                                        "${order.user.firstName} ${order.user.lastName}",
                                    address:
                                        "${order.shippingAddress.street}, ${order.shippingAddress.city}",
                                    onCallPressed: () {
                                      UrlLauncherHelper.callPhone(
                                        order.user.phone,
                                      );
                                    },
                                    onWhatsappPressed: () {
                                      UrlLauncherHelper.launchWhatsApp(
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
                                    key: const Key(
                                      KeysStrings.activeOrderItemsList,
                                    ),
                                    children: List.generate(
                                      order.orderItems.length,
                                      (index) {
                                        final item = order.orderItems[index];
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            top: 8.0,
                                          ),
                                          child: OrderDetailsItem(
                                            imageUrl: item.product.imgCover,
                                            title: item.product.title,
                                            price: item.price.toString(),
                                            numberOfItem: item.quantity.toInt(),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  OrderDetailsRowText(
                                    key: const Key(
                                      KeysStrings.activeOrderTotal,
                                    ),
                                    title: localizations.total,
                                    value:
                                        "${localizations.egp} ${order.totalPrice}",
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
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black100.withValues(
                                  alpha: 0.1,
                                ),
                                blurRadius: 4,
                                offset: const Offset(0, -2),
                              ),
                            ],
                          ),
                          child: CustomButton(
                            key: const Key(KeysStrings.activeOrderButton),
                            isLoading: state.updateOrderStatusState.isLoading,
                            title: order.orderStatus.buttonTitle(localizations),
                            onPressed:
                                order.orderStatus == OrderStatusEnum.delivered
                                ? null
                                : () => _onButtonPressed(context, order),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
