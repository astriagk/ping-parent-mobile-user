import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../../common/openfreemap_config.dart';

/// OSRM (Open Source Routing Machine) service for route calculation
/// Free routing service with no API key required
class OFMRoutingService {
  static const String _baseUrl = OpenFreeMapConfig.osrmBaseUrl;

  /// Get route between multiple waypoints
  /// Returns route points, distance (meters), and duration (seconds)
  static Future<OFMRouteResult?> getRoute(
    List<LatLng> waypoints, {
    OFMRouteProfile profile = OFMRouteProfile.driving,
    bool alternatives = false,
    bool steps = true,
  }) async {
    if (waypoints.length < 2) return null;

    try {
      final coordinates = waypoints
          .map((point) => '${point.longitude},${point.latitude}')
          .join(';');

      final url = Uri.parse(
        '$_baseUrl/route/v1/${profile.value}/$coordinates?'
        'overview=full&geometries=geojson&steps=$steps'
        '&alternatives=$alternatives',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['code'] != 'Ok') {
          return null;
        }

        final route = data['routes'][0];
        final geometry = route['geometry']['coordinates'] as List;
        final points = geometry
            .map<LatLng>((coord) => LatLng(coord[1].toDouble(), coord[0].toDouble()))
            .toList();

        List<OFMRouteStep>? routeSteps;
        if (steps && route['legs'] != null) {
          routeSteps = [];
          for (var leg in route['legs']) {
            for (var step in leg['steps']) {
              final stepGeometry = step['geometry']['coordinates'] as List;
              routeSteps.add(OFMRouteStep(
                instruction: step['maneuver']['instruction'] ?? '',
                distance: step['distance'].toDouble(),
                duration: step['duration'].toDouble(),
                name: step['name'] ?? '',
                maneuverType: step['maneuver']['type'] ?? '',
                points: stepGeometry
                    .map<LatLng>((c) => LatLng(c[1].toDouble(), c[0].toDouble()))
                    .toList(),
              ));
            }
          }
        }

        return OFMRouteResult(
          points: points,
          distanceMeters: route['distance'].toDouble(),
          durationSeconds: route['duration'].toDouble(),
          steps: routeSteps,
        );
      }
    } catch (e) {
      // Handle error silently
    }
    return null;
  }

  /// Get optimized route for multiple stops (Traveling Salesman Problem)
  /// Uses OSRM's trip service to optimize the order of waypoints
  static Future<OFMTripResult?> getOptimizedTrip(
    List<LatLng> waypoints, {
    OFMRouteProfile profile = OFMRouteProfile.driving,
    bool roundtrip = false,
    OFMTripSource source = OFMTripSource.first,
    OFMTripDestination destination = OFMTripDestination.last,
  }) async {
    if (waypoints.length < 2) return null;

    try {
      final coordinates = waypoints
          .map((point) => '${point.longitude},${point.latitude}')
          .join(';');

      final url = Uri.parse(
        '$_baseUrl/trip/v1/${profile.value}/$coordinates?'
        'overview=full&geometries=geojson&steps=true'
        '&roundtrip=$roundtrip&source=${source.value}&destination=${destination.value}',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['code'] != 'Ok') {
          return null;
        }

        final trip = data['trips'][0];
        final geometry = trip['geometry']['coordinates'] as List;
        final points = geometry
            .map<LatLng>((coord) => LatLng(coord[1].toDouble(), coord[0].toDouble()))
            .toList();

        // Get optimized waypoint order
        final waypointsData = data['waypoints'] as List;
        final optimizedOrder = waypointsData
            .map<int>((w) => w['waypoint_index'] as int)
            .toList();

        return OFMTripResult(
          points: points,
          distanceMeters: trip['distance'].toDouble(),
          durationSeconds: trip['duration'].toDouble(),
          optimizedOrder: optimizedOrder,
        );
      }
    } catch (e) {
      // Handle error silently
    }
    return null;
  }

  /// Calculate matrix of distances and durations between multiple points
  static Future<OFMDistanceMatrix?> getDistanceMatrix(
    List<LatLng> sources,
    List<LatLng> destinations, {
    OFMRouteProfile profile = OFMRouteProfile.driving,
  }) async {
    try {
      final allPoints = [...sources, ...destinations];
      final coordinates = allPoints
          .map((point) => '${point.longitude},${point.latitude}')
          .join(';');

      final sourceIndices = List.generate(sources.length, (i) => i).join(';');
      final destIndices = List.generate(
        destinations.length,
        (i) => i + sources.length,
      ).join(';');

      final url = Uri.parse(
        '$_baseUrl/table/v1/${profile.value}/$coordinates?'
        'sources=$sourceIndices&destinations=$destIndices'
        '&annotations=distance,duration',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['code'] != 'Ok') {
          return null;
        }

        return OFMDistanceMatrix(
          distances: (data['distances'] as List)
              .map((row) => (row as List)
                  .map<double>((d) => d != null ? (d as num).toDouble() : double.infinity)
                  .toList())
              .toList(),
          durations: (data['durations'] as List)
              .map((row) => (row as List)
                  .map<double>((d) => d != null ? (d as num).toDouble() : double.infinity)
                  .toList())
              .toList(),
        );
      }
    } catch (e) {
      // Handle error silently
    }
    return null;
  }

  /// Get nearest road/path point for a given coordinate
  static Future<LatLng?> getNearestPoint(
    LatLng point, {
    OFMRouteProfile profile = OFMRouteProfile.driving,
  }) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/nearest/v1/${profile.value}/${point.longitude},${point.latitude}',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['code'] != 'Ok') {
          return null;
        }

        final location = data['waypoints'][0]['location'] as List;
        return LatLng(location[1].toDouble(), location[0].toDouble());
      }
    } catch (e) {
      // Handle error silently
    }
    return null;
  }
}

/// Route calculation result
class OFMRouteResult {
  final List<LatLng> points;
  final double distanceMeters;
  final double durationSeconds;
  final List<OFMRouteStep>? steps;

  OFMRouteResult({
    required this.points,
    required this.distanceMeters,
    required this.durationSeconds,
    this.steps,
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

/// Individual route step with turn-by-turn instruction
class OFMRouteStep {
  final String instruction;
  final double distance;
  final double duration;
  final String name;
  final String maneuverType;
  final List<LatLng> points;

  OFMRouteStep({
    required this.instruction,
    required this.distance,
    required this.duration,
    required this.name,
    required this.maneuverType,
    required this.points,
  });
}

/// Trip optimization result
class OFMTripResult extends OFMRouteResult {
  final List<int> optimizedOrder;

  OFMTripResult({
    required super.points,
    required super.distanceMeters,
    required super.durationSeconds,
    required this.optimizedOrder,
  });
}

/// Distance and duration matrix between multiple points
class OFMDistanceMatrix {
  final List<List<double>> distances; // in meters
  final List<List<double>> durations; // in seconds

  OFMDistanceMatrix({
    required this.distances,
    required this.durations,
  });

  /// Get distance from source index to destination index
  double getDistance(int sourceIndex, int destIndex) {
    return distances[sourceIndex][destIndex];
  }

  /// Get duration from source index to destination index
  double getDuration(int sourceIndex, int destIndex) {
    return durations[sourceIndex][destIndex];
  }
}

/// Route profile (transportation mode)
enum OFMRouteProfile {
  driving('driving'),
  walking('foot'),
  cycling('bike');

  final String value;
  const OFMRouteProfile(this.value);
}

/// Trip source constraint
enum OFMTripSource {
  any('any'),
  first('first');

  final String value;
  const OFMTripSource(this.value);
}

/// Trip destination constraint
enum OFMTripDestination {
  any('any'),
  last('last');

  final String value;
  const OFMTripDestination(this.value);
}
