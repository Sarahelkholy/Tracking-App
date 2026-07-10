import 'package:open_route_service/open_route_service.dart';
void main() async {
  final client = OpenRouteService(apiKey: 'eyJvcmciOiI1YjNjZTM1OTc4NTExMTAwMDFjZjYyNDgiLCJpZCI6IjhiNDc5YjUxMDY4NDQ3NTg4MWJlNDljODQwMDcxZGQ3IiwiaCI6Im11cm11cjY0In0=');
  try {
    final routeCoordinates = await client.directionsRouteCoordsGet(
      startCoordinate: ORSCoordinate(
        latitude: 30.0444, // Cairo
        longitude: 31.2357,
      ),
      endCoordinate: ORSCoordinate(
        latitude: 31.2001, // Alex
        longitude: 29.9187,
      ),
    );
    print("Point 0: lat=${routeCoordinates[0].latitude}, lon=${routeCoordinates[0].longitude}");
  } catch (e) {
    print("Error: $e");
  }
}
