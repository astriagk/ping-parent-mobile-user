import 'package:flutter/material.dart';

/// Map controls overlay widget
/// Provides zoom, location, and layer controls for the map
class OFMMapControls extends StatelessWidget {
  final VoidCallback? onZoomIn;
  final VoidCallback? onZoomOut;
  final VoidCallback? onMyLocation;
  final VoidCallback? onLayers;
  final VoidCallback? onCompass;
  final bool showLayersButton;
  final bool showCompassButton;
  final Color? backgroundColor;
  final Color? iconColor;
  final double buttonSize;

  const OFMMapControls({
    super.key,
    this.onZoomIn,
    this.onZoomOut,
    this.onMyLocation,
    this.onLayers,
    this.onCompass,
    this.showLayersButton = false,
    this.showCompassButton = false,
    this.backgroundColor,
    this.iconColor,
    this.buttonSize = 48,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? Colors.white;
    final icColor = iconColor ?? Colors.grey.shade800;

    return Positioned(
      right: 16,
      bottom: 100,
      child: Column(
        children: [
          if (showCompassButton && onCompass != null) ...[
            _buildControlButton(
              icon: Icons.explore,
              onPressed: onCompass,
              bgColor: bgColor,
              icColor: icColor,
            ),
            const SizedBox(height: 8),
          ],
          if (showLayersButton && onLayers != null) ...[
            _buildControlButton(
              icon: Icons.layers,
              onPressed: onLayers,
              bgColor: bgColor,
              icColor: icColor,
            ),
            const SizedBox(height: 8),
          ],
          _buildControlButton(
            icon: Icons.add,
            onPressed: onZoomIn,
            bgColor: bgColor,
            icColor: icColor,
          ),
          const SizedBox(height: 8),
          _buildControlButton(
            icon: Icons.remove,
            onPressed: onZoomOut,
            bgColor: bgColor,
            icColor: icColor,
          ),
          const SizedBox(height: 8),
          _buildControlButton(
            icon: Icons.my_location,
            onPressed: onMyLocation,
            bgColor: bgColor,
            icColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    VoidCallback? onPressed,
    required Color bgColor,
    required Color icColor,
  }) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(8),
      shadowColor: Colors.black26,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: buttonSize,
          height: buttonSize,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: icColor, size: buttonSize * 0.5),
        ),
      ),
    );
  }
}

/// Location info card overlay
/// Shows selected location details with optional navigation
class OFMLocationInfoCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? address;
  final String? distance;
  final String? duration;
  final VoidCallback? onClose;
  final VoidCallback? onNavigate;
  final VoidCallback? onShare;
  final Widget? leading;

  const OFMLocationInfoCard({
    super.key,
    required this.title,
    this.subtitle,
    this.address,
    this.distance,
    this.duration,
    this.onClose,
    this.onNavigate,
    this.onShare,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Material(
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
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                // Header row
                Row(
                  children: [
                    if (leading != null) ...[
                      leading!,
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              subtitle!,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (onClose != null)
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: onClose,
                      ),
                  ],
                ),
                // Address
                if (address != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          address!,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                // Distance and duration
                if (distance != null || duration != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (distance != null) ...[
                        Icon(Icons.straighten, size: 16, color: Colors.grey.shade700),
                        const SizedBox(width: 4),
                        Text(distance!, style: const TextStyle(fontWeight: FontWeight.w500)),
                        const SizedBox(width: 16),
                      ],
                      if (duration != null) ...[
                        Icon(Icons.access_time, size: 16, color: Colors.grey.shade700),
                        const SizedBox(width: 4),
                        Text(duration!, style: const TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ],
                  ),
                ],
                // Action buttons
                if (onNavigate != null || onShare != null) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      if (onNavigate != null)
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: onNavigate,
                            icon: const Icon(Icons.directions, color: Colors.white),
                            label: const Text('Navigate', style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      if (onNavigate != null && onShare != null)
                        const SizedBox(width: 12),
                      if (onShare != null)
                        IconButton(
                          onPressed: onShare,
                          icon: const Icon(Icons.share),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.grey.shade200,
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Route info card showing distance, duration, and waypoints
class OFMRouteInfoCard extends StatelessWidget {
  final String distance;
  final String duration;
  final int waypointCount;
  final VoidCallback? onStartNavigation;
  final VoidCallback? onClose;
  final VoidCallback? onOptimize;

  const OFMRouteInfoCard({
    super.key,
    required this.distance,
    required this.duration,
    this.waypointCount = 0,
    this.onStartNavigation,
    this.onClose,
    this.onOptimize,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.route, color: Colors.blue),
                  const SizedBox(width: 8),
                  const Text(
                    'Route Information',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  if (onClose != null)
                    GestureDetector(
                      onTap: onClose,
                      child: const Icon(Icons.close, size: 20),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildInfoItem(Icons.straighten, distance, 'Distance'),
                  const SizedBox(width: 24),
                  _buildInfoItem(Icons.access_time, duration, 'Duration'),
                  if (waypointCount > 0) ...[
                    const SizedBox(width: 24),
                    _buildInfoItem(Icons.place, '$waypointCount', 'Stops'),
                  ],
                ],
              ),
              if (onStartNavigation != null || onOptimize != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (onOptimize != null) ...[
                      OutlinedButton.icon(
                        onPressed: onOptimize,
                        icon: const Icon(Icons.auto_fix_high, size: 18),
                        label: const Text('Optimize'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (onStartNavigation != null)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onStartNavigation,
                          icon: const Icon(Icons.navigation, color: Colors.white, size: 18),
                          label: const Text('Start', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.grey.shade600),
            const SizedBox(width: 4),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}

/// Loading overlay for map
class OFMLoadingOverlay extends StatelessWidget {
  final String? message;
  final Color? backgroundColor;

  const OFMLoadingOverlay({
    super.key,
    this.message,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? Colors.black.withValues(alpha: 0.3),
      child: Center(
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                if (message != null) ...[
                  const SizedBox(height: 16),
                  Text(message!),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Search bar overlay for map
class OFMSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final bool readOnly;

  const OFMSearchBar({
    super.key,
    this.controller,
    this.hintText,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      left: 16,
      right: 16,
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(8),
        child: TextField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          decoration: InputDecoration(
            hintText: hintText ?? 'Search location...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: controller?.text.isNotEmpty == true
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      controller?.clear();
                      onClear?.call();
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ),
    );
  }
}

/// Tracking stats overlay
class OFMTrackingStats extends StatelessWidget {
  final String distance;
  final String duration;
  final String? speed;
  final int? pointsCount;
  final bool isTracking;
  final VoidCallback? onToggleTracking;

  const OFMTrackingStats({
    super.key,
    required this.distance,
    required this.duration,
    this.speed,
    this.pointsCount,
    this.isTracking = false,
    this.onToggleTracking,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(Icons.straighten, distance, 'Distance'),
              _buildStatItem(Icons.access_time, duration, 'Duration'),
              if (speed != null) _buildStatItem(Icons.speed, speed!, 'Speed'),
              if (pointsCount != null)
                _buildStatItem(Icons.location_on, '$pointsCount', 'Points'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 24, color: Colors.blue),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
