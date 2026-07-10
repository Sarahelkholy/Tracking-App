import 'package:open_route_service/open_route_service.dart';

void main() async {
  final client = OpenRouteService(
    apiKey:
        'eyJvcmciOiI1YjNjZTM1OTc4NTExMTAwMDFjZjYyNDgiLCJpZCI6IjhiNDc5YjUxMDY4NDQ3NTg4MWJlNDljODQwMDcxZGQ3IiwiaCI6Im11cm11cjY0In0=',
  );
  try {
    print('Testing original (lat, lon)');
    final routeCoordinates = await client.directionsRouteCoordsGet(
      startCoordinate: const ORSCoordinate(latitude: 30.0444, longitude: 31.2357),
      endCoordinate: const ORSCoordinate(latitude: 31.2001, longitude: 29.9187),
    );
    print(
      "Point 0: lat=${routeCoordinates[0].latitude}, lon=${routeCoordinates[0].longitude}",
    );
  } catch (e) {
    print("Error original: $e");
  }

  try {
    print('Testing swapped (lon, lat)');
    final routeCoordinates = await client.directionsRouteCoordsGet(
      startCoordinate: const ORSCoordinate(latitude: 31.2357, longitude: 30.0444),
      endCoordinate: const ORSCoordinate(latitude: 29.9187, longitude: 31.2001),
    );
    print(
      "Point 0: lat=${routeCoordinates[0].latitude}, lon=${routeCoordinates[0].longitude}",
    );
  } catch (e) {
    print("Error swapped: $e");
  }
}
