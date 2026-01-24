import 'package:flutter/material.dart';

import 'ofm_basic_map_screen.dart';
import 'ofm_location_picker_screen.dart';
import 'ofm_multi_marker_screen.dart';
import 'ofm_realtime_tracking_screen.dart';
import 'ofm_route_planning_screen.dart';

/// Main menu screen for all OpenFreeMap examples
/// Provides navigation to different map implementation examples
class OFMExamplesMenu extends StatelessWidget {
  const OFMExamplesMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('OpenFreeMap Examples'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header card
          Card(
            elevation: 0,
            color: Colors.blue.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                              'Free Map Solution',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.blue.shade900,
                              ),
                            ),
                            Text(
                              'No API keys required',
                              style: TextStyle(
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'These examples demonstrate free mapping solutions using OpenStreetMap tiles and OSRM routing. Perfect for apps that need maps without subscription costs.',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Example cards
          _buildExampleCard(
            context,
            title: '1. Basic Map',
            description: 'Simple map with current location and multiple tile styles',
            icon: Icons.map_outlined,
            color: Colors.blue,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const OFMBasicMapScreen(),
              ),
            ),
          ),
          _buildExampleCard(
            context,
            title: '2. Location Picker',
            description: 'Interactive location selection with address lookup',
            icon: Icons.location_searching,
            color: Colors.green,
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
          _buildExampleCard(
            context,
            title: '3. Multi-Marker Map',
            description: 'Multiple pickup/drop locations with route polyline',
            icon: Icons.place,
            color: Colors.orange,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const OFMMultiMarkerScreen(),
              ),
            ),
          ),
          _buildExampleCard(
            context,
            title: '4. Real-time Tracking',
            description: 'Live GPS tracking with route path and statistics',
            icon: Icons.navigation,
            color: Colors.purple,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const OFMRealtimeTrackingScreen(),
              ),
            ),
          ),
          _buildExampleCard(
            context,
            title: '5. Route Planning',
            description: 'OSRM routing with waypoints and optimization',
            icon: Icons.route,
            color: Colors.teal,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const OFMRoutePlanningScreen(),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Implementation notes
          Card(
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
                        'Implementation Notes',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.amber.shade900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildNote('All maps use FREE OpenStreetMap tiles'),
                  _buildNote('No API keys or accounts required'),
                  _buildNote('OSRM routing is completely free'),
                  _buildNote('Location picker returns lat/lng + address'),
                  _buildNote('Real-time tracking uses device GPS'),
                  _buildNote('Route optimization uses TSP algorithm'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Cost info
          Card(
            elevation: 0,
            color: Colors.green.shade50,
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
                      Icon(Icons.attach_money, color: Colors.green.shade700),
                      const SizedBox(width: 8),
                      Text(
                        'Cost Breakdown',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green.shade900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildCostItem('Map Tiles', 'FREE', 'OpenStreetMap/CartoDB'),
                  _buildCostItem('Routing', 'FREE', 'OSRM public server'),
                  _buildCostItem('Geocoding', 'FREE', 'Nominatim'),
                  _buildCostItem('GPS Location', 'FREE', 'Device sensor'),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Monthly Cost',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade900,
                        ),
                      ),
                      Text(
                        '\$0',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNote(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, size: 16, color: Colors.green.shade600),
          const SizedBox(width: 8),
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

  Widget _buildCostItem(String service, String cost, String provider) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(service, style: const TextStyle(fontSize: 13)),
          ),
          Expanded(
            child: Text(
              cost,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              provider,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
