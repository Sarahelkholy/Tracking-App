import 'package:open_route_service/open_route_service.dart';
void main() async {
  final client = OpenRouteService(apiKey: 'eyJvcmciOiI1YjNjZTM1OTc4NTExMTAwMDFjZjYyNDgiLCJpZCI6IjhiNDc5YjUxMDY4NDQ3NTg4MWJlNDljODQwMDcxZGQ3IiwiaCI6Im11cm11cjY0In0=');
  try {
    print('Testing SF route');
    final routeCoordinates = await client.directionsRouteCoordsGet(
      startCoordinate: ORSCoordinate(
        latitude: 37.4219983, 
        longitude: -122.084,
      ),
      endCoordinate: ORSCoordinate(
        latitude: 37.7749, 
        longitude: -122.4194,
      ),
    );
    print("Success: " + routeCoordinates.length.toString() + " points");
    if (routeCoordinates.isNotEmpty) {
      print("First point: " + routeCoordinates[0].latitude.toString() + ", " + routeCoordinates[0].longitude.toString());
    }
  } catch (e) {
    print("Error: " + e.toString());
  }
}
