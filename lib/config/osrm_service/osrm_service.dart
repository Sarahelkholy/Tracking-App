import 'package:flower_driver/secret_keys.dart';
import 'package:open_route_service/open_route_service.dart';
import 'package:latlong2/latlong.dart';

class OsrmService {
  // TODO: Replace with your actual OpenRouteService API Key
  final OpenRouteService client = OpenRouteService(
    apiKey: SecretKeys.openRouteService,
  );

  Future<List<LatLng>> getRoute({
    required LatLng start,
    required LatLng end,
  }) async {
    try {
      final List<ORSCoordinate> routeCoordinates = await client
          .directionsRouteCoordsGet(
            startCoordinate: ORSCoordinate(
              latitude: start.latitude,
              longitude: start.longitude,
            ),
            endCoordinate: ORSCoordinate(
              latitude: end.latitude,
              longitude: end.longitude,
            ),
          );

      return routeCoordinates
          .map<LatLng>((point) => LatLng(point.latitude, point.longitude))
          .toList();
    } catch (e) {
      print('Error getting route: $e');
      return [];
    }
  }
}
