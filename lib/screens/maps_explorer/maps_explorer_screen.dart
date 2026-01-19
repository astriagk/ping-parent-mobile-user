import 'package:flutter/material.dart';

// OSM Maps (Basic flutter_map implementation)
import '../maps/basic_map_screen.dart';
import '../maps/location_picker_screen.dart';
import '../maps/multi_marker_map_screen.dart';
import '../maps/realtime_tracking_screen.dart';
import '../maps/route_planning_screen.dart';

// OpenFreeMap (Enhanced free maps)
import '../open_free_maps/ofm_basic_map_screen.dart';
import '../open_free_maps/ofm_location_picker_screen.dart';
import '../open_free_maps/ofm_multi_marker_screen.dart';
import '../open_free_maps/ofm_realtime_tracking_screen.dart';
import '../open_free_maps/ofm_route_planning_screen.dart';

// TomTom Maps (Premium maps)
import '../tomtom_maps/tt_basic_map_screen.dart';
import '../tomtom_maps/tt_location_picker_screen.dart';

/// Maps Explorer Screen
/// Shows all available map providers and their features
class MapsExplorerScreen extends StatelessWidget {
  const MapsExplorerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('Maps Explorer'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          _buildHeader(context),
          const SizedBox(height: 20),

          // OSM Maps Section (Basic Implementation)
          _buildMapProviderSection(
            context,
            title: 'OSM Maps (Basic)',
            subtitle: 'Standard OpenStreetMap implementation',
            icon: Icons.map,
            color: Colors.orange,
            features: [
              'Simple OSM tiles',
              'Basic markers',
              'Route polylines',
              'GPS tracking',
            ],
            maps: [
              _MapItem(
                title: 'Basic Map',
                description: 'Simple OpenStreetMap with current location',
                icon: Icons.map_outlined,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BasicMapScreen(),
                  ),
                ),
              ),
              _MapItem(
                title: 'Location Picker',
                description: 'Draggable marker with address lookup',
                icon: Icons.location_searching,
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LocationPickerScreen(),
                    ),
                  );
                  if (result != null && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Selected: ${result['address']}'),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                },
              ),
              _MapItem(
                title: 'Multi-Marker Map',
                description: 'Multiple pickup/drop locations with route',
                icon: Icons.place,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MultiMarkerMapScreen(),
                  ),
                ),
              ),
              _MapItem(
                title: 'Real-time Tracking',
                description: 'Live GPS tracking with route path',
                icon: Icons.navigation,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RealtimeTrackingScreen(),
                  ),
                ),
              ),
              _MapItem(
                title: 'Route Planning',
                description: 'OSRM routing with waypoint optimization',
                icon: Icons.route,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RoutePlanningScreen(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // OpenFreeMap Section (Enhanced)
          _buildMapProviderSection(
            context,
            title: 'OpenFreeMap (Enhanced)',
            subtitle: 'No API key required - Completely free',
            icon: Icons.public,
            color: Colors.green,
            features: [
              'Multiple tile styles (CartoDB, etc.)',
              'OSRM routing (free)',
              'Nominatim geocoding (free)',
              'Advanced markers & polylines',
            ],
            maps: [
              _MapItem(
                title: 'Basic Map',
                description: 'Multiple tile styles with controls',
                icon: Icons.map_outlined,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OFMBasicMapScreen(),
                  ),
                ),
              ),
              _MapItem(
                title: 'Location Picker',
                description: 'Interactive location selection',
                icon: Icons.location_searching,
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OFMLocationPickerScreen(),
                    ),
                  );
                  if (result != null && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Selected: ${result['address']}'),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                },
              ),
              _MapItem(
                title: 'Multi-Marker Map',
                description: 'Advanced markers with route display',
                icon: Icons.place,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OFMMultiMarkerScreen(),
                  ),
                ),
              ),
              _MapItem(
                title: 'Real-time Tracking',
                description: 'Live tracking with statistics',
                icon: Icons.navigation,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OFMRealtimeTrackingScreen(),
                  ),
                ),
              ),
              _MapItem(
                title: 'Route Planning',
                description: 'OSRM with trip optimization',
                icon: Icons.route,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OFMRoutePlanningScreen(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // TomTom Section
          _buildMapProviderSection(
            context,
            title: 'TomTom Maps (Premium)',
            subtitle: 'Premium maps with traffic & routing',
            icon: Icons.explore,
            color: Colors.blue,
            features: [
              'High-quality map tiles',
              'Real-time traffic data',
              'Turn-by-turn navigation',
              'Search & geocoding API',
            ],
            maps: [
              _MapItem(
                title: 'Basic Map',
                description: 'TomTom tiles with day/night styles',
                icon: Icons.map_outlined,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TTBasicMapScreen(),
                  ),
                ),
              ),
              _MapItem(
                title: 'Location Picker',
                description: 'Pick location with TomTom maps',
                icon: Icons.location_searching,
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TTLocationPickerScreen(),
                    ),
                  );
                  if (result != null && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Selected: ${result['address']}'),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Comparison Card
          _buildComparisonCard(context),
          const SizedBox(height: 16),

          // Quick Tips
          _buildQuickTips(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.blue.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.map,
                color: Colors.blue.shade700,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Map Providers',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.blue.shade900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '3 providers with 12 map examples',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapProviderSection(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required List<String> features,
    required List<_MapItem> maps,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: color,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${maps.length} screens',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Features
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: features
                  .map((f) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 14,
                              color: color,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              f,
                              style: const TextStyle(fontSize: 11),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),

          const Divider(height: 1),

          // Map Items
          ...maps.map((map) => _buildMapTile(context, map, color)),
        ],
      ),
    );
  }

  Widget _buildMapTile(BuildContext context, _MapItem map, Color color) {
    return InkWell(
      onTap: map.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(map.icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    map.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    map.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonCard(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.purple.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.compare_arrows, color: Colors.purple.shade700),
                const SizedBox(width: 8),
                Text(
                  'Quick Comparison',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.purple.shade900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1.2),
                2: FlexColumnWidth(1.2),
                3: FlexColumnWidth(1.2),
              },
              children: [
                _buildTableRow('Feature', 'OSM', 'Free', 'TomTom',
                    isHeader: true),
                _buildTableRow('Cost', 'Free', 'Free', 'API Key'),
                _buildTableRow('Tiles', 'Basic', 'Good', 'Premium'),
                _buildTableRow('Traffic', 'No', 'No', 'Yes'),
                _buildTableRow('Routing', 'OSRM', 'OSRM', 'TomTom'),
                _buildTableRow('Screens', '5', '5', '2'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(String label, String osm, String free, String tomtom,
      {bool isHeader = false}) {
    final style = isHeader
        ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)
        : const TextStyle(fontSize: 11);

    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(label, style: style),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child:
              Text(osm, style: style.copyWith(color: Colors.orange.shade700)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child:
              Text(free, style: style.copyWith(color: Colors.green.shade700)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child:
              Text(tomtom, style: style.copyWith(color: Colors.blue.shade700)),
        ),
      ],
    );
  }

  Widget _buildQuickTips(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.amber.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb_outline, color: Colors.amber.shade700),
                const SizedBox(width: 8),
                Text(
                  'Quick Tips',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.amber.shade900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTip('OSM Maps - Best for simple, basic implementations'),
            _buildTip('OpenFreeMap - Best for production apps (no cost)'),
            _buildTip('TomTom - Best for traffic-aware routing & premium tiles'),
            _buildTip('All providers support location picker'),
            _buildTip('Route planning available in OSM & OpenFreeMap'),
          ],
        ),
      ),
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.arrow_right, size: 16, color: Colors.amber.shade700),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapItem {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  _MapItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });
}
