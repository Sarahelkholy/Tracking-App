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
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
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
        if (location != null) {
          _mapController.move(
            LatLng(location.latitude, location.longitude),
            _mapController.camera.zoom,
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

        final markers = <Marker>[
          if (driverLatLng != null)
            Marker(
              point: driverLatLng,
              width: 50,
              height: 50,
              child: const Icon(
                Icons.local_shipping,
                color: Colors.blue,
                size: 36,
              ),
            ),

          if (storeLatLng != null)
            Marker(
              point: storeLatLng,
              width: 50,
              height: 50,
              child: const Icon(Icons.store, color: Colors.red, size: 36),
            ),

          if (userLatLng != null)
            Marker(
              point: userLatLng,
              width: 50,
              height: 50,
              child: const Icon(
                Icons.location_on,
                color: Colors.green,
                size: 36,
              ),
            ),
        ];

        final startLatLng = driverLatLng;
        final endLatLng = order.orderStatus.step < OrderStatusEnum.picked.step
            ? storeLatLng
            : userLatLng;

        if (startLatLng != null && endLatLng != null) {
          if (startLatLng != _lastStart || endLatLng != _lastEnd) {
            _lastStart = startLatLng;
            _lastEnd = endLatLng;
            _routeFuture = _osrmService.getRoute(
              start: startLatLng,
              end: endLatLng,
            );
          }
        }

        return Scaffold(
          appBar: AppBar(
            key: const Key(KeysStrings.activeOrderAppBar),
            title: Text(localizations.orderDetails),
          ),
          body: Stack(
            fit: StackFit.expand,
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter:
                      driverLatLng ??
                      storeLatLng ??
                      userLatLng ??
                      const LatLng(30.0, 31.0),
                  initialZoom: 14,
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
                        final points = snapshot.data ?? [startLatLng, endLatLng];
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
            ],
          ),
        );
      },
    );
  }
}
