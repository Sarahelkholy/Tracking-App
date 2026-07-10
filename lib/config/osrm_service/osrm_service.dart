import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';

class OsrmService {
  final Dio _dio = Dio();

  Future<List<LatLng>> getRoute({
    required LatLng start,
    required LatLng end,
  }) async {
    final response = await _dio.get(
      'https://router.project-osrm.org/route/v1/driving/'
      '${start.longitude},${start.latitude};'
      '${end.longitude},${end.latitude}',
      queryParameters: {'overview': 'full', 'geometries': 'geojson'},
    );

    final coordinates = response.data['routes'][0]['geometry']['coordinates'];

    return coordinates
        .map<LatLng>(
          (point) => LatLng(
            (point[1] as num).toDouble(),
            (point[0] as num).toDouble(),
          ),
        )
        .toList();
  }
}
