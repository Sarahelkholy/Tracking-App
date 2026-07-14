import 'package:flower_driver/config/di/di.dart';
import 'package:flower_driver/config/driver/manager/driver_cubit.dart';
import 'package:flower_driver/core/helpers/event_handler_mixin.dart';
import 'package:flower_driver/core/helpers/url_launcher_helper.dart';
import 'package:flower_driver/core/localization/l10n/app_localizations.dart';
import 'package:flower_driver/core/shared_widgets/custom_button.dart';
import 'package:flower_driver/core/shared_widgets/custom_error_widget.dart';
import 'package:flower_driver/core/shared_widgets/custom_loading_indicator.dart';
import 'package:flower_driver/core/utils/app_colors.dart';
import 'package:flower_driver/core/utils/app_constants.dart';
import 'package:flower_driver/core/utils/app_text_styles.dart';
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
import 'package:flower_driver/features/orders/presentation/widgets/active_order_details/order_status_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import '../../../../../config/osrm_service/osrm_service.dart';

class ActiveOrderDetailsScreen extends StatefulWidget {
  const ActiveOrderDetailsScreen({super.key});

  @override
  State<ActiveOrderDetailsScreen> createState() =>
      _ActiveOrderDetailsScreenState();
}

class _ActiveOrderDetailsScreenState extends State<ActiveOrderDetailsScreen>
    with EventHandlerMixin<ActiveOrderDetailsScreen> {
  late AppLocalizations localizations;
  final MapController _mapController = MapController();
  final OsrmService _osrmService = OsrmService();
  Future<List<LatLng>>? _routeFuture;
  LatLng? _lastStart;
  LatLng? _lastEnd;
  bool _isMapReady = false;

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
        body: BlocConsumer<ActiveOrderCubit, ActiveOrderState>(
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
            if (location != null && _isMapReady) {
              _mapController.move(
                LatLng(location.latitude, location.longitude),
                _mapController.camera.zoom,
              );
              debugPrint('location: ${location.latitude}');
              debugPrint('location: ${location.longitude}');
            }
          },
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

            final markers = <Marker>[
              if (driverLatLng != null)
                Marker(
                  point: driverLatLng,
                  width: 50,
                  height: 50,
                  child: const Icon(
                    Icons.local_shipping,
                    color: AppColors.blue,
                    size: 36,
                  ),
                ),
              if (storeLatLng != null)
                Marker(
                  point: storeLatLng,
                  width: 50,
                  height: 50,
                  child: const Icon(
                    Icons.store,
                    color: AppColors.red,
                    size: 36,
                  ),
                ),
              if (userLatLng != null)
                Marker(
                  point: userLatLng,
                  width: 50,
                  height: 50,
                  child: const Icon(
                    Icons.location_on,
                    color: AppColors.green,
                    size: 36,
                  ),
                ),
            ];

            final startLatLng = driverLatLng;
            final endLatLng =
                order.orderStatus.step < OrderStatusEnum.picked.step
                ? storeLatLng
                : (userLatLng ?? storeLatLng);

            if (startLatLng != null && endLatLng != null) {
              bool shouldFetch = false;
              if (_lastStart == null || _lastEnd == null) {
                shouldFetch = true;
              } else if (endLatLng != _lastEnd) {
                shouldFetch = true;
              } else {
                final distance = const Distance().as(
                  LengthUnit.Meter,
                  startLatLng,
                  _lastStart!,
                );
                if (distance > 50) {
                  shouldFetch = true;
                }
              }

              if (shouldFetch) {
                _lastStart = startLatLng;
                _lastEnd = endLatLng;
                _routeFuture = _osrmService.getRoute(
                  start: startLatLng,
                  end: endLatLng,
                );
              }
            }

            return Column(
              children: [
                SizedBox(
                  height: 250,
                  child: Stack(
                    children: [
                      FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter:
                              driverLatLng ??
                              storeLatLng ??
                              userLatLng ??
                              const LatLng(30.0444, 31.2357), // Cairo, Egypt
                          initialZoom: 14,
                          onMapReady: () {
                            if (mounted) {
                              setState(() {
                                _isMapReady = true;
                              });
                            }
                          },
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.flower.driver',
                          ),
                          if (startLatLng != null && endLatLng != null)
                            FutureBuilder<List<LatLng>>(
                              future: _routeFuture,
                              builder: (context, snapshot) {
                                final points =
                                    snapshot.data ?? [startLatLng, endLatLng];
                                return PolylineLayer(
                                  polylines: [
                                    Polyline(
                                      points: points,
                                      color: AppColors.primaryColor,
                                      strokeWidth: 5,
                                    ),
                                  ],
                                );
                              },
                            ),
                          MarkerLayer(markers: markers),
                        ],
                      ),
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FloatingActionButton(
                              heroTag: "zoom_in_btn",
                              mini: true,
                              backgroundColor: AppColors.white,
                              onPressed: () {
                                if (_isMapReady) {
                                  _mapController.move(
                                    _mapController.camera.center,
                                    _mapController.camera.zoom + 1,
                                  );
                                }
                              },
                              child: const Icon(
                                Icons.add,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            FloatingActionButton(
                              heroTag: "zoom_out_btn",
                              mini: true,
                              backgroundColor: AppColors.white,
                              onPressed: () {
                                if (_isMapReady) {
                                  _mapController.move(
                                    _mapController.camera.center,
                                    _mapController.camera.zoom - 1,
                                  );
                                }
                              },
                              child: const Icon(
                                Icons.remove,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            if (driverLatLng != null) ...[
                              const SizedBox(height: 8),
                              FloatingActionButton(
                                heroTag: "my_location_btn",
                                mini: true,
                                backgroundColor: AppColors.white,
                                onPressed: () {
                                  if (_isMapReady) {
                                    _mapController.move(driverLatLng, 15);
                                  }
                                },
                                child: const Icon(
                                  Icons.my_location,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
