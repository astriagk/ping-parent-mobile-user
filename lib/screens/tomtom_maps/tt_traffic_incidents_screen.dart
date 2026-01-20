import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../../common/tomtom_config.dart';

/// TomTom Traffic Incidents Screen
/// Demonstrates TomTom's premium traffic incident data
/// Shows real-time accidents, road closures, and other incidents
class TTTrafficIncidentsScreen extends StatefulWidget {
  const TTTrafficIncidentsScreen({super.key});

  @override
  State<TTTrafficIncidentsScreen> createState() =>
      _TTTrafficIncidentsScreenState();
}

class _TTTrafficIncidentsScreenState extends State<TTTrafficIncidentsScreen> {
  final MapController _mapController = MapController();
  double _currentZoom = 11.0;
  LatLng _center = const LatLng(37.7749, -122.4194); // San Francisco

  List<TrafficIncident> _incidents = [];
  bool _isLoading = false;
  String? _errorMessage;
  TrafficIncident? _selectedIncident;

  // Incident category filters
  final Map<int, bool> _categoryFilters = {
    0: true, // Unknown
    1: true, // Accident
    2: true, // Fog
    3: true, // Dangerous conditions
    4: true, // Rain
    5: true, // Ice
    6: true, // Jam
    7: true, // Lane closed
    8: true, // Road closed
    9: true, // Road works
    10: true, // Wind
    11: true, // Flooding
    14: true, // Broken down vehicle
  };

  @override
  void initState() {
    super.initState();
    _fetchIncidents();
  }

  Future<void> _fetchIncidents() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Calculate bounding box around center
      final lat = _center.latitude;
      final lng = _center.longitude;
      final delta = 0.3; // ~30km radius

      final bbox = '${lng - delta},${lat - delta},${lng + delta},${lat + delta}';
      final url =
          'https://api.tomtom.com/traffic/services/5/incidentDetails?key=${TomTomConfig.apiKey}&bbox=$bbox&fields={incidents{type,geometry{type,coordinates},properties{id,iconCategory,magnitudeOfDelay,events{description,code},startTime,endTime,from,to,length,delay,roadNumbers,aci{probabilityOfOccurrence,numberOfReports,lastReportTime}}}}';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final incidentsList = <TrafficIncident>[];

        if (data['incidents'] != null) {
          for (final incident in data['incidents']) {
            try {
              incidentsList.add(TrafficIncident.fromJson(incident));
            } catch (e) {
              // Skip malformed incidents
            }
          }
        }

        setState(() {
          _incidents = incidentsList;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load incidents: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  List<Marker> _buildIncidentMarkers() {
    return _incidents
        .where((incident) => _categoryFilters[incident.iconCategory] ?? true)
        .map((incident) {
      return Marker(
        point: incident.location,
        width: 40,
        height: 40,
        child: GestureDetector(
          onTap: () => setState(() => _selectedIncident = incident),
          child: Container(
            decoration: BoxDecoration(
              color: incident.color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              incident.icon,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Traffic Incidents'),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchIncidents,
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _center,
              initialZoom: _currentZoom,
              minZoom: 5.0,
              maxZoom: 18.0,
              onPositionChanged: (position, hasGesture) {
                _currentZoom = position.zoom;
                _center = position.center;
              },
              onTap: (_, __) => setState(() => _selectedIncident = null),
            ),
            children: [
              // Base map layer
              TileLayer(
                urlTemplate: TomTomConfig.allTileOptions[0]['url']!,
                userAgentPackageName: TomTomConfig.userAgentPackageName,
              ),
              // Incident markers
              MarkerLayer(markers: _buildIncidentMarkers()),
            ],
          ),
          // Loading indicator
          if (_isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
          // Error message
          if (_errorMessage != null)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(child: Text(_errorMessage!)),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => setState(() => _errorMessage = null),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          // Incident count badge
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.red.shade700,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.warning, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    '${_incidents.length} Incidents',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Zoom controls
          Positioned(
            right: 16,
            bottom: _selectedIncident != null ? 220 : 100,
            child: Column(
              children: [
                _buildControlButton(
                  icon: Icons.add,
                  onPressed: () {
                    final newZoom = (_currentZoom + 1).clamp(5.0, 18.0);
                    _mapController.move(_center, newZoom);
                  },
                ),
                const SizedBox(height: 8),
                _buildControlButton(
                  icon: Icons.remove,
                  onPressed: () {
                    final newZoom = (_currentZoom - 1).clamp(5.0, 18.0);
                    _mapController.move(_center, newZoom);
                  },
                ),
              ],
            ),
          ),
          // Selected incident details
          if (_selectedIncident != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildIncidentCard(_selectedIncident!),
            ),
          // Legend
          Positioned(
            bottom: _selectedIncident != null ? 220 : 100,
            left: 16,
            child: _buildLegend(),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.grey.shade800, size: 24),
        ),
      ),
    );
  }

  Widget _buildIncidentCard(TrafficIncident incident) {
    return Material(
      elevation: 8,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: incident.color,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(incident.icon, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          incident.categoryName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        if (incident.description != null)
                          Text(
                            incident.description!,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(() => _selectedIncident = null),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (incident.from != null || incident.to != null)
                _buildInfoRow(
                  Icons.route,
                  '${incident.from ?? ''} → ${incident.to ?? ''}',
                ),
              if (incident.delay != null && incident.delay! > 0)
                _buildInfoRow(
                  Icons.access_time,
                  'Delay: ${(incident.delay! / 60).round()} min',
                ),
              if (incident.length != null)
                _buildInfoRow(
                  Icons.straighten,
                  'Length: ${(incident.length! / 1000).toStringAsFixed(1)} km',
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Incident Types',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 8),
          _buildLegendItem(Colors.red, Icons.car_crash, 'Accident'),
          _buildLegendItem(Colors.orange, Icons.construction, 'Road works'),
          _buildLegendItem(Colors.purple, Icons.block, 'Road closed'),
          _buildLegendItem(Colors.amber, Icons.traffic, 'Traffic jam'),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 12),
          ),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter Incident Types',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildFilterChip(1, 'Accident', setModalState),
                  _buildFilterChip(6, 'Traffic Jam', setModalState),
                  _buildFilterChip(8, 'Road Closed', setModalState),
                  _buildFilterChip(9, 'Road Works', setModalState),
                  _buildFilterChip(7, 'Lane Closed', setModalState),
                  _buildFilterChip(2, 'Fog', setModalState),
                  _buildFilterChip(4, 'Rain', setModalState),
                  _buildFilterChip(5, 'Ice', setModalState),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(int category, String label, StateSetter setModalState) {
    return FilterChip(
      label: Text(label),
      selected: _categoryFilters[category] ?? true,
      onSelected: (selected) {
        setModalState(() => _categoryFilters[category] = selected);
        setState(() {});
      },
    );
  }
}

/// Traffic incident data model
class TrafficIncident {
  final String id;
  final LatLng location;
  final int iconCategory;
  final String? description;
  final String? from;
  final String? to;
  final int? delay;
  final int? length;
  final int magnitudeOfDelay;

  TrafficIncident({
    required this.id,
    required this.location,
    required this.iconCategory,
    this.description,
    this.from,
    this.to,
    this.delay,
    this.length,
    this.magnitudeOfDelay = 0,
  });

  factory TrafficIncident.fromJson(Map<String, dynamic> json) {
    final properties = json['properties'] ?? {};
    final geometry = json['geometry'] ?? {};
    final coordinates = geometry['coordinates'];

    // Handle both Point and LineString geometries
    double lat, lng;
    if (geometry['type'] == 'Point') {
      lng = coordinates[0].toDouble();
      lat = coordinates[1].toDouble();
    } else if (geometry['type'] == 'LineString' && coordinates.isNotEmpty) {
      lng = coordinates[0][0].toDouble();
      lat = coordinates[0][1].toDouble();
    } else {
      throw Exception('Invalid geometry');
    }

    String? description;
    final events = properties['events'];
    if (events != null && events.isNotEmpty) {
      description = events[0]['description'];
    }

    return TrafficIncident(
      id: properties['id'] ?? '',
      location: LatLng(lat, lng),
      iconCategory: properties['iconCategory'] ?? 0,
      description: description,
      from: properties['from'],
      to: properties['to'],
      delay: properties['delay'],
      length: properties['length'],
      magnitudeOfDelay: properties['magnitudeOfDelay'] ?? 0,
    );
  }

  String get categoryName {
    switch (iconCategory) {
      case 1:
        return 'Accident';
      case 2:
        return 'Fog';
      case 3:
        return 'Dangerous Conditions';
      case 4:
        return 'Rain';
      case 5:
        return 'Ice';
      case 6:
        return 'Traffic Jam';
      case 7:
        return 'Lane Closed';
      case 8:
        return 'Road Closed';
      case 9:
        return 'Road Works';
      case 10:
        return 'Wind';
      case 11:
        return 'Flooding';
      case 14:
        return 'Broken Down Vehicle';
      default:
        return 'Unknown';
    }
  }

  Color get color {
    switch (iconCategory) {
      case 1:
        return Colors.red;
      case 2:
      case 3:
      case 4:
      case 5:
      case 10:
      case 11:
        return Colors.blue;
      case 6:
        return Colors.amber;
      case 7:
      case 8:
        return Colors.purple;
      case 9:
        return Colors.orange;
      case 14:
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }

  IconData get icon {
    switch (iconCategory) {
      case 1:
        return Icons.car_crash;
      case 2:
        return Icons.foggy;
      case 3:
        return Icons.warning;
      case 4:
        return Icons.water_drop;
      case 5:
        return Icons.ac_unit;
      case 6:
        return Icons.traffic;
      case 7:
        return Icons.remove_road;
      case 8:
        return Icons.block;
      case 9:
        return Icons.construction;
      case 10:
        return Icons.air;
      case 11:
        return Icons.flood;
      case 14:
        return Icons.car_repair;
      default:
        return Icons.info;
    }
  }
}
