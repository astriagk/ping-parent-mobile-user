import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

/// OSRM (Open Source Routing Machine) service for route calculation
class OSRMService {
  static const String _baseUrl = 'http://router.project-osrm.org';

  /// Get route between multiple waypoints
  /// Returns route points, distance (meters), and duration (seconds)
  static Future<RouteResult?> getRoute(List<LatLng> waypoints) async {
    if (waypoints.length < 2) return null;

    try {
      // Build coordinates string
      final coordinates = waypoints
          .map((point) => '${point.longitude},${point.latitude}')
          .join(';');

      // Build API URL
      final url = Uri.parse(
        '$_baseUrl/route/v1/driving/$coordinates?'
        'overview=full&geometries=geojson&steps=true',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final route = data['routes'][0];

        // Parse geometry
        final geometry = route['geometry']['coordinates'] as List;
        final points =
            geometry.map((coord) => LatLng(coord[1], coord[0])).toList();

        return RouteResult(
          points: points,
          distanceMeters: route['distance'].toDouble(),
          durationSeconds: route['duration'].toDouble(),
        );
      }
    } catch (e) {
      // Handle error
    }
    return null;
  }

  /// Get optimized route for multiple stops (Traveling Salesman Problem)
  /// This uses OSRM's trip service to optimize the order of waypoints
  static Future<RouteResult?> getOptimizedTrip(
    List<LatLng> waypoints, {
    LatLng? startPoint,
    LatLng? endPoint,
  }) async {
    if (waypoints.length < 2) return null;

    try {
      // Build coordinates string
      final coordinates = waypoints
          .map((point) => '${point.longitude},${point.latitude}')
          .join(';');

      // Build API URL
      final url = Uri.parse(
        '$_baseUrl/trip/v1/driving/$coordinates?'
        'overview=full&geometries=geojson&steps=true',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final trip = data['trips'][0];

        // Parse geometry
        final geometry = trip['geometry']['coordinates'] as List;
        final points =
            geometry.map((coord) => LatLng(coord[1], coord[0])).toList();

        return RouteResult(
          points: points,
          distanceMeters: trip['distance'].toDouble(),
          durationSeconds: trip['duration'].toDouble(),
        );
      }
    } catch (e) {
      // Handle error
    }
    return null;
  }

  /// Calculate matrix of distances and durations between multiple points
  static Future<DistanceMatrix?> getDistanceMatrix(
    List<LatLng> sources,
    List<LatLng> destinations,
  ) async {
    try {
      // Build coordinates string (sources first, then destinations)
      final allPoints = [...sources, ...destinations];
      final coordinates = allPoints
          .map((point) => '${point.longitude},${point.latitude}')
          .join(';');

      final url = Uri.parse(
        '$_baseUrl/table/v1/driving/$coordinates?'
        'sources=${List.generate(sources.length, (i) => i).join(';')}&'
        'destinations=${List.generate(destinations.length, (i) => i + sources.length).join(';')}',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return DistanceMatrix(
          distances: (data['distances'] as List)
              .map((row) =>
                  (row as List).map((d) => (d as num).toDouble()).toList())
              .toList()
              .cast<List<double>>(),
          durations: (data['durations'] as List)
              .map((row) =>
                  (row as List).map((d) => (d as num).toDouble()).toList())
              .toList()
              .cast<List<double>>(),
        );
      }
    } catch (e) {
      // Handle error
    }
    return null;
  }
}

/// Result from route calculation
class RouteResult {
  final List<LatLng> points;
  final double distanceMeters;
  final double durationSeconds;

  RouteResult({
    required this.points,
    required this.distanceMeters,
    required this.durationSeconds,
  });

  String get formattedDistance {
    if (distanceMeters < 1000) {
      return '${distanceMeters.toStringAsFixed(0)} m';
    }
    return '${(distanceMeters / 1000).toStringAsFixed(2)} km';
  }

  String get formattedDuration {
    final minutes = (durationSeconds / 60).round();
    if (minutes < 60) {
      return '$minutes min';
    }
    final hours = (minutes / 60).floor();
    final remainingMinutes = minutes % 60;
    return '$hours hr $remainingMinutes min';
  }
}

/// Distance and duration matrix between multiple points
class DistanceMatrix {
  final List<List<double>> distances; // in meters
  final List<List<double>> durations; // in seconds

  DistanceMatrix({
    required this.distances,
    required this.durations,
  });
}
