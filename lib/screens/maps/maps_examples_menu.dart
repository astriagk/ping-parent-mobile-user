import '../../config.dart';
import 'basic_map_screen.dart';
import 'location_picker_screen.dart';
import 'multi_marker_map_screen.dart';
import 'realtime_tracking_screen.dart';
import 'route_planning_screen.dart';

/// Main menu screen for all map examples
class MapsExamplesMenu extends StatelessWidget {
  const MapsExamplesMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context).appTheme;
    return Scaffold(
      backgroundColor: theme.screenBg,
      appBar: AppBar(
        backgroundColor: theme.primary,
        title: Text('Flutter Map Examples', style: TextStyle(color: theme.white)),
        iconTheme: IconThemeData(color: theme.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildExampleCard(
            context,
            title: '1. Basic Map',
            description: 'Simple OpenStreetMap with current location marker',
            icon: Icons.map,
            color: theme.activeColor,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BasicMapScreen(),
              ),
            ),
          ),
          _buildExampleCard(
            context,
            title: '2. Location Picker',
            description:
                'Interactive map with draggable marker and address lookup',
            icon: Icons.location_searching,
            color: theme.success,
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
          _buildExampleCard(
            context,
            title: '3. Multi-Marker Map',
            description: 'Multiple pickup/drop locations with route display',
            icon: Icons.place,
            color: theme.yellowIcon,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MultiMarkerMapScreen(),
              ),
            ),
          ),
          _buildExampleCard(
            context,
            title: '4. Real-time Tracking',
            description: 'Live GPS tracking with route path and statistics',
            icon: Icons.navigation,
            color: theme.primary,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RealtimeTrackingScreen(),
              ),
            ),
          ),
          _buildExampleCard(
            context,
            title: '5. Route Planning',
            description: 'OSRM routing with multiple waypoints optimization',
            icon: Icons.route,
            color: theme.alertZone,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RoutePlanningScreen(),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            color: theme.bgBox,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb_outline, color: theme.yellowIcon),
                      const SizedBox(width: 8),
                      Text(
                        'Implementation Notes',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: theme.darkText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildNote(context, 'All maps use FREE OpenStreetMap tiles'),
                  _buildNote(context, 'No API keys required'),
                  _buildNote(context, 'Location picker returns lat/lng + address'),
                  _buildNote(context, 'OSRM routing is completely free'),
                  _buildNote(context, 'Real-time tracking uses device GPS (no cost)'),
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
    final theme = appColor(context).appTheme;
    return Card(
      color: theme.white,
      margin: const EdgeInsets.only(bottom: 12),
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
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: theme.darkText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: theme.lightText,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: theme.lightText),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNote(BuildContext context, String text) {
    final theme = appColor(context).appTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(Icons.check_circle, size: 16, color: theme.success),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13, color: theme.darkText),
            ),
          ),
        ],
      ),
    );
  }
}
