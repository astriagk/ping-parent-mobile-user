import '../../config.dart';

/// Map controls overlay widget
class MapControls extends StatelessWidget {
  final VoidCallback? onZoomIn;
  final VoidCallback? onZoomOut;
  final VoidCallback? onMyLocation;
  final VoidCallback? onLayers;
  final bool showLayersButton;

  const MapControls({
    super.key,
    this.onZoomIn,
    this.onZoomOut,
    this.onMyLocation,
    this.onLayers,
    this.showLayersButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context).appTheme;
    return Positioned(
      right: 16,
      bottom: 100,
      child: Column(
        children: [
          if (showLayersButton && onLayers != null)
            _buildControlButton(
              context: context,
              icon: Icons.layers,
              onPressed: onLayers,
            ),
          if (showLayersButton && onLayers != null) const SizedBox(height: 8),
          _buildControlButton(
            context: context,
            icon: Icons.add,
            onPressed: onZoomIn,
          ),
          const SizedBox(height: 8),
          _buildControlButton(
            context: context,
            icon: Icons.remove,
            onPressed: onZoomOut,
          ),
          const SizedBox(height: 8),
          _buildControlButton(
            context: context,
            icon: Icons.my_location,
            onPressed: onMyLocation,
            color: theme.activeColor,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required BuildContext context,
    required IconData icon,
    VoidCallback? onPressed,
    Color? color,
  }) {
    final theme = appColor(context).appTheme;
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
            color: theme.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color ?? theme.darkText),
        ),
      ),
    );
  }
}

/// Location info card overlay
class LocationInfoCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? distance;
  final String? duration;
  final VoidCallback? onClose;
  final VoidCallback? onNavigate;

  const LocationInfoCard({
    super.key,
    required this.title,
    this.subtitle,
    this.distance,
    this.duration,
    this.onClose,
    this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context).appTheme;
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Material(
        elevation: 8,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: theme.darkText,
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            subtitle!,
                            style: TextStyle(
                              color: theme.lightText,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (onClose != null)
                    IconButton(
                      icon: Icon(Icons.close, color: theme.darkText),
                      onPressed: onClose,
                    ),
                ],
              ),
              if (distance != null || duration != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (distance != null) ...[
                      Icon(Icons.straighten, size: 16, color: theme.darkText),
                      const SizedBox(width: 4),
                      Text(distance!, style: TextStyle(color: theme.darkText)),
                      const SizedBox(width: 16),
                    ],
                    if (duration != null) ...[
                      Icon(Icons.access_time, size: 16, color: theme.darkText),
                      const SizedBox(width: 4),
                      Text(duration!, style: TextStyle(color: theme.darkText)),
                    ],
                  ],
                ),
              ],
              if (onNavigate != null) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onNavigate,
                    icon: Icon(Icons.directions, color: theme.white),
                    label: Text('Navigate', style: TextStyle(color: theme.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Loading overlay for map
class MapLoadingOverlay extends StatelessWidget {
  final String? message;

  const MapLoadingOverlay({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context).appTheme;
    return Container(
      color: theme.darkText.withValues(alpha: 0.3),
      child: Center(
        child: Card(
          color: theme.white,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: theme.primary),
                if (message != null) ...[
                  const SizedBox(height: 16),
                  Text(message!, style: TextStyle(color: theme.darkText)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
