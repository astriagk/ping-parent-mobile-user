import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../../common/tomtom_config.dart';

/// TomTom Routing API service for route calculation
/// Uses TomTom's powerful routing engine with traffic awareness
class TTRoutingService {
  static const String _baseUrl = TomTomConfig.routingBaseUrl;
  static const String _apiKey = TomTomConfig.apiKey;

  /// Get route between multiple waypoints
  /// Returns route points, distance (meters), and duration (seconds)
  static Future<TTRouteResult?> getRoute(
    List<LatLng> waypoints, {
    TTRouteProfile profile = TTRouteProfile.car,
    bool traffic = true,
    bool alternatives = false,
    TTRouteType routeType = TTRouteType.fastest,
  }) async {
    if (waypoints.length < 2) return null;

    try {
      final coordinates = waypoints
          .map((point) => '${point.latitude},${point.longitude}')
          .join(':');

      final url = Uri.parse(
        '$_baseUrl/calculateRoute/$coordinates/json?'
        'key=$_apiKey'
        '&travelMode=${profile.value}'
        '&traffic=$traffic'
        '&routeType=${routeType.value}'
        '&maxAlternatives=${alternatives ? 2 : 0}'
        '&instructionsType=text'
        '&routeRepresentation=polyline',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['routes'] == null || (data['routes'] as List).isEmpty) {
          return null;
        }

        final route = data['routes'][0];
        final summary = route['summary'];
        final legs = route['legs'] as List;

        // Extract points from legs
        final List<LatLng> points = [];
        final List<TTRouteStep> steps = [];

        for (var leg in legs) {
          for (var point in leg['points']) {
            points.add(LatLng(
              point['latitude'].toDouble(),
              point['longitude'].toDouble(),
            ));
          }

          // Extract instructions if available
          if (route['guidance'] != null) {
            for (var instruction in route['guidance']['instructions']) {
              steps.add(TTRouteStep(
                instruction: instruction['message'] ?? '',
                distance: (instruction['routeOffsetInMeters'] ?? 0).toDouble(),
                duration: 0,
                name: instruction['street'] ?? '',
                maneuverType: instruction['maneuver'] ?? '',
              ));
            }
          }
        }

        return TTRouteResult(
          points: points,
          distanceMeters: summary['lengthInMeters'].toDouble(),
          durationSeconds: summary['travelTimeInSeconds'].toDouble(),
          trafficDelaySeconds: summary['trafficDelayInSeconds']?.toDouble() ?? 0,
          steps: steps.isNotEmpty ? steps : null,
        );
      }
    } catch (e) {
      // Handle error silently
    }
    return null;
  }

  /// Get route with traffic information
  static Future<TTRouteResult?> getRouteWithTraffic(
    LatLng origin,
    LatLng destination, {
    TTRouteProfile profile = TTRouteProfile.car,
  }) async {
    return getRoute(
      [origin, destination],
      profile: profile,
      traffic: true,
    );
  }

  /// Calculate distance matrix between multiple points
  static Future<TTDistanceMatrix?> getDistanceMatrix(
    List<LatLng> origins,
    List<LatLng> destinations, {
    TTRouteProfile profile = TTRouteProfile.car,
  }) async {
    try {
      final originsStr = origins
          .map((p) => {'point': {'latitude': p.latitude, 'longitude': p.longitude}})
          .toList();
      final destinationsStr = destinations
          .map((p) => {'point': {'latitude': p.latitude, 'longitude': p.longitude}})
          .toList();

      final url = Uri.parse(
        'https://api.tomtom.com/routing/1/matrix/sync/json?key=$_apiKey',
      );

      final body = jsonEncode({
        'origins': originsStr,
        'destinations': destinationsStr,
        'options': {
          'travelMode': profile.value,
        },
      });

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final matrix = data['matrix'] as List;

        final distances = <List<double>>[];
        final durations = <List<double>>[];

        for (var row in matrix) {
          final distanceRow = <double>[];
          final durationRow = <double>[];

          for (var cell in row) {
            if (cell['statusCode'] == 200) {
              final response = cell['response'];
              final summary = response['routeSummary'];
              distanceRow.add(summary['lengthInMeters'].toDouble());
              durationRow.add(summary['travelTimeInSeconds'].toDouble());
            } else {
              distanceRow.add(double.infinity);
              durationRow.add(double.infinity);
            }
          }

          distances.add(distanceRow);
          durations.add(durationRow);
        }

        return TTDistanceMatrix(
          distances: distances,
          durations: durations,
        );
      }
    } catch (e) {
      // Handle error silently
    }
    return null;
  }
}

/// TomTom Search API service for geocoding and place search
class TTSearchService {
  static const String _baseUrl = TomTomConfig.searchBaseUrl;
  static const String _apiKey = TomTomConfig.apiKey;

  /// Search for places/addresses by query text
  static Future<List<TTSearchResult>> search(
    String query, {
    LatLng? center,
    int limit = 10,
    String? countryCode,
  }) async {
    try {
      var url = '$_baseUrl/search/$query.json?key=$_apiKey&limit=$limit';

      if (center != null) {
        url += '&lat=${center.latitude}&lon=${center.longitude}';
      }
      if (countryCode != null) {
        url += '&countrySet=$countryCode';
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'] as List;

        return results.map((r) {
          final position = r['position'];
          final address = r['address'];

          return TTSearchResult(
            name: r['poi']?['name'] ?? address['freeformAddress'] ?? '',
            address: address['freeformAddress'] ?? '',
            position: LatLng(
              position['lat'].toDouble(),
              position['lon'].toDouble(),
            ),
            type: r['type'] ?? '',
            distance: r['dist']?.toDouble(),
          );
        }).toList();
      }
    } catch (e) {
      // Handle error silently
    }
    return [];
  }

  /// Reverse geocode - get address from coordinates
  static Future<TTSearchResult?> reverseGeocode(LatLng position) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/reverseGeocode/${position.latitude},${position.longitude}.json?key=$_apiKey',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final addresses = data['addresses'] as List;

        if (addresses.isNotEmpty) {
          final address = addresses.first['address'];
          return TTSearchResult(
            name: address['streetName'] ?? address['municipality'] ?? '',
            address: address['freeformAddress'] ?? '',
            position: position,
            type: 'Address',
          );
        }
      }
    } catch (e) {
      // Handle error silently
    }
    return null;
  }

  /// Autocomplete search suggestions
  static Future<List<TTSearchResult>> autocomplete(
    String query, {
    LatLng? center,
    int limit = 5,
  }) async {
    try {
      var url =
          '$_baseUrl/autocomplete/$query.json?key=$_apiKey&limit=$limit&language=en-US';

      if (center != null) {
        url += '&lat=${center.latitude}&lon=${center.longitude}';
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'] as List;

        return results.map((r) {
          final segments = r['segments'] as List;
          final fullText = segments.map((s) => s['value']).join('');

          return TTSearchResult(
            name: fullText,
            address: fullText,
            position: const LatLng(0, 0), // Position not available in autocomplete
            type: r['type'] ?? '',
          );
        }).toList();
      }
    } catch (e) {
      // Handle error silently
    }
    return [];
  }
}

/// Route calculation result
class TTRouteResult {
  final List<LatLng> points;
  final double distanceMeters;
  final double durationSeconds;
  final double trafficDelaySeconds;
  final List<TTRouteStep>? steps;

  TTRouteResult({
    required this.points,
    required this.distanceMeters,
    required this.durationSeconds,
    this.trafficDelaySeconds = 0,
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

  String get formattedTrafficDelay {
    if (trafficDelaySeconds <= 0) return 'No delay';
    final minutes = (trafficDelaySeconds / 60).round();
    if (minutes < 1) return 'No significant delay';
    return '+$minutes min due to traffic';
  }
}

/// Individual route step with turn-by-turn instruction
class TTRouteStep {
  final String instruction;
  final double distance;
  final double duration;
  final String name;
  final String maneuverType;

  TTRouteStep({
    required this.instruction,
    required this.distance,
    required this.duration,
    required this.name,
    required this.maneuverType,
  });
}

/// Distance and duration matrix between multiple points
class TTDistanceMatrix {
  final List<List<double>> distances; // in meters
  final List<List<double>> durations; // in seconds

  TTDistanceMatrix({
    required this.distances,
    required this.durations,
  });

  /// Get distance from origin index to destination index
  double getDistance(int originIndex, int destIndex) {
    return distances[originIndex][destIndex];
  }

  /// Get duration from origin index to destination index
  double getDuration(int originIndex, int destIndex) {
    return durations[originIndex][destIndex];
  }
}

/// Search result from TomTom Search API
class TTSearchResult {
  final String name;
  final String address;
  final LatLng position;
  final String type;
  final double? distance;

  TTSearchResult({
    required this.name,
    required this.address,
    required this.position,
    required this.type,
    this.distance,
  });
}

/// Route profile (transportation mode)
enum TTRouteProfile {
  car('car'),
  truck('truck'),
  taxi('taxi'),
  bus('bus'),
  van('van'),
  motorcycle('motorcycle'),
  bicycle('bicycle'),
  pedestrian('pedestrian');

  final String value;
  const TTRouteProfile(this.value);
}

/// Route type preference
enum TTRouteType {
  fastest('fastest'),
  shortest('shortest'),
  eco('eco'),
  thrilling('thrilling');

  final String value;
  const TTRouteType(this.value);
}
