import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../common/tomtom_config.dart';

/// TomTom Traffic Flow Screen
/// Demonstrates TomTom's premium traffic flow visualization
/// Shows real-time traffic conditions with color-coded road segments
class TTTrafficFlowScreen extends StatefulWidget {
  const TTTrafficFlowScreen({super.key});

  @override
  State<TTTrafficFlowScreen> createState() => _TTTrafficFlowScreenState();
}

class _TTTrafficFlowScreenState extends State<TTTrafficFlowScreen> {
  final MapController _mapController = MapController();
  double _currentZoom = 12.0;
  LatLng _center = const LatLng(37.7749, -122.4194); // San Francisco

  // Traffic flow styles
  int _selectedFlowStyle = 0;
  final List<Map<String, dynamic>> _flowStyles = [
    {
      'name': 'Absolute',
      'style': 'absolute',
      'description': 'Shows actual speed colors',
    },
    {
      'name': 'Relative',
      'style': 'relative',
      'description': 'Shows speed vs free flow',
    },
    {
      'name': 'Relative-delay',
      'style': 'relative-delay',
      'description': 'Shows delay-based colors',
    },
  ];

  // Traffic tile thickness options
  int _selectedThickness = 1;
  final List<int> _thicknessOptions = [1, 2, 4, 6, 10];

  String _buildTrafficFlowUrl() {
    final style = _flowStyles[_selectedFlowStyle]['style'];
    final thickness = _thicknessOptions[_selectedThickness];
    return 'https://api.tomtom.com/traffic/map/4/tile/flow/$style/{z}/{x}/{y}.png?key=${TomTomConfig.apiKey}&thickness=$thickness';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Traffic Flow'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.layers),
            onPressed: _showLayerOptions,
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
                setState(() {
                  _currentZoom = position.zoom;
                  _center = position.center;
                });
              },
            ),
            children: [
              // Base map layer
              TileLayer(
                urlTemplate: TomTomConfig.allTileOptions[0]['url']!,
                userAgentPackageName: TomTomConfig.userAgentPackageName,
              ),
              // Traffic flow overlay
              TileLayer(
                urlTemplate: _buildTrafficFlowUrl(),
                userAgentPackageName: TomTomConfig.userAgentPackageName,
              ),
            ],
          ),
          // Zoom controls
          Positioned(
            right: 16,
            bottom: 100,
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
          // Traffic legend
          Positioned(
            bottom: 100,
            left: 16,
            child: _buildTrafficLegend(),
          ),
          // Current style indicator
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: _buildStyleIndicator(),
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
      shadowColor: Colors.black26,
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

  Widget _buildTrafficLegend() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Traffic Flow',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 8),
          _buildLegendItem(Colors.green, 'Free flow'),
          _buildLegendItem(Colors.yellow.shade700, 'Moderate'),
          _buildLegendItem(Colors.orange, 'Slow'),
          _buildLegendItem(Colors.red, 'Very slow'),
          _buildLegendItem(Colors.red.shade900, 'Standstill'),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 4,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildStyleIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue.shade700,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.traffic, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Text(
            '${_flowStyles[_selectedFlowStyle]['name']} • Thickness: ${_thicknessOptions[_selectedThickness]}',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  void _showLayerOptions() {
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
                'Traffic Flow Style',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              ...List.generate(_flowStyles.length, (index) {
                final style = _flowStyles[index];
                return ListTile(
                  title: Text(style['name']),
                  subtitle: Text(style['description'],
                      style: const TextStyle(fontSize: 12)),
                  leading: Radio<int>(
                    value: index,
                    groupValue: _selectedFlowStyle,
                    onChanged: (value) {
                      setModalState(() => _selectedFlowStyle = value!);
                      setState(() {});
                      Navigator.pop(context);
                    },
                  ),
                  onTap: () {
                    setModalState(() => _selectedFlowStyle = index);
                    setState(() {});
                    Navigator.pop(context);
                  },
                );
              }),
              const Divider(),
              const Text(
                'Line Thickness',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: List.generate(_thicknessOptions.length, (index) {
                  return ChoiceChip(
                    label: Text('${_thicknessOptions[index]}'),
                    selected: _selectedThickness == index,
                    onSelected: (selected) {
                      if (selected) {
                        setModalState(() => _selectedThickness = index);
                        setState(() {});
                        Navigator.pop(context);
                      }
                    },
                  );
                }),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
