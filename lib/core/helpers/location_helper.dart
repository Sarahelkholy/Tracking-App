import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

abstract class LocationHelper {
  static Future<Position> getCurrentLocation() async {
    // Check permission FIRST so the dialog appears even if GPS is off.
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission permanently denied.');
    }

    // Check if location services are enabled.
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  Future<String> getAddressFromLatLong(String latLong) async {
    final parts = latLong.split(',');

    final latitude = double.parse(parts[0]);
    final longitude = double.parse(parts[1]);

    final placemarks = await placemarkFromCoordinates(latitude, longitude);

    if (placemarks.isEmpty) return 'Unknown location';

    final place = placemarks.first;

    return [
      place.name,
      place.street,
      place.locality,
      place.administrativeArea,
      place.country,
    ].where((e) => e != null && e.isNotEmpty).join(', ');
  }

  static String positionToString(Position position) {
    return "${position.latitude},${position.longitude}";
  }
}
