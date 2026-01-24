import '../../config.dart';

/// Location info card overlay
/// Shows selected location details with optional navigation
class MapLocationInfoCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? address;
  final String? distance;
  final String? duration;
  final VoidCallback? onClose;
  final VoidCallback? onNavigate;
  final VoidCallback? onShare;
  final Widget? leading;

  const MapLocationInfoCard({
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
            color: theme.bgBox,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
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
                      color: theme.lightText.withValues(alpha: 0.3),
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
                            style: AppCss.lexendMedium18.textColor(theme.darkText),
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              subtitle!,
                              style: AppCss.lexendMedium14.textColor(theme.lightText),
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
                // Address
                if (address != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: theme.lightText),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          address!,
                          style: AppCss.lexendMedium13.textColor(theme.lightText),
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
                        Icon(Icons.straighten, size: 16, color: theme.darkText),
                        const SizedBox(width: 4),
                        Text(
                          distance!,
                          style: AppCss.lexendMedium14.textColor(theme.darkText),
                        ),
                        const SizedBox(width: 16),
                      ],
                      if (duration != null) ...[
                        Icon(Icons.access_time, size: 16, color: theme.darkText),
                        const SizedBox(width: 4),
                        Text(
                          duration!,
                          style: AppCss.lexendMedium14.textColor(theme.darkText),
                        ),
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
                            label: Text(
                              'Navigate',
                              style: AppCss.lexendMedium14.textColor(Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.primary,
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
                          icon: Icon(Icons.share, color: theme.darkText),
                          style: IconButton.styleFrom(
                            backgroundColor: theme.lightText.withValues(alpha: 0.1),
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
class MapRouteInfoCard extends StatelessWidget {
  final String distance;
  final String duration;
  final int waypointCount;
  final VoidCallback? onStartNavigation;
  final VoidCallback? onClose;
  final VoidCallback? onOptimize;
  final String? trafficInfo;

  const MapRouteInfoCard({
    super.key,
    required this.distance,
    required this.duration,
    this.waypointCount = 0,
    this.onStartNavigation,
    this.onClose,
    this.onOptimize,
    this.trafficInfo,
  });

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context).appTheme;

    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: Card(
        elevation: 4,
        color: theme.bgBox,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.route, color: theme.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Route Information',
                    style: AppCss.lexendMedium16.textColor(theme.darkText),
                  ),
                  const Spacer(),
                  if (onClose != null)
                    GestureDetector(
                      onTap: onClose,
                      child: Icon(Icons.close, size: 20, color: theme.darkText),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildInfoItem(context, Icons.straighten, distance, 'Distance'),
                  const SizedBox(width: 24),
                  _buildInfoItem(context, Icons.access_time, duration, 'Duration'),
                  if (waypointCount > 0) ...[
                    const SizedBox(width: 24),
                    _buildInfoItem(context, Icons.place, '$waypointCount', 'Stops'),
                  ],
                ],
              ),
              if (trafficInfo != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.traffic, size: 16, color: theme.yellowIcon),
                    const SizedBox(width: 4),
                    Text(
                      trafficInfo!,
                      style: AppCss.lexendMedium12.textColor(theme.yellowIcon),
                    ),
                  ],
                ),
              ],
              if (onStartNavigation != null || onOptimize != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (onOptimize != null) ...[
                      OutlinedButton.icon(
                        onPressed: onOptimize,
                        icon: Icon(Icons.auto_fix_high, size: 18, color: theme.primary),
                        label: Text(
                          'Optimize',
                          style: AppCss.lexendMedium12.textColor(theme.primary),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: theme.primary),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (onStartNavigation != null)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onStartNavigation,
                          icon: const Icon(Icons.navigation,
                              color: Colors.white, size: 18),
                          label: Text(
                            'Start',
                            style: AppCss.lexendMedium14.textColor(Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primary,
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

  Widget _buildInfoItem(BuildContext context, IconData icon, String value, String label) {
    final theme = appColor(context).appTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: theme.lightText),
            const SizedBox(width: 4),
            Text(
              value,
              style: AppCss.lexendMedium16.textColor(theme.darkText),
            ),
          ],
        ),
        Text(
          label,
          style: AppCss.lexendMedium12.textColor(theme.lightText),
        ),
      ],
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
      color: Colors.black.withValues(alpha: 0.3),
      child: Center(
        child: Card(
          color: theme.bgBox,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: theme.primary),
                if (message != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    message!,
                    style: AppCss.lexendMedium14.textColor(theme.darkText),
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

/// Search bar overlay for map
class MapSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final bool readOnly;

  const MapSearchBar({
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
    final theme = appColor(context).appTheme;

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
          style: AppCss.lexendMedium14.textColor(theme.darkText),
          decoration: InputDecoration(
            hintText: hintText ?? 'Search location...',
            hintStyle: AppCss.lexendMedium14.textColor(theme.lightText),
            prefixIcon: Icon(Icons.search, color: theme.lightText),
            suffixIcon: controller?.text.isNotEmpty == true
                ? IconButton(
                    icon: Icon(Icons.clear, color: theme.lightText),
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
            fillColor: theme.bgBox,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ),
    );
  }
}

/// Tracking stats overlay
class MapTrackingStats extends StatelessWidget {
  final String distance;
  final String duration;
  final String? speed;
  final int? pointsCount;
  final bool isTracking;
  final VoidCallback? onToggleTracking;

  const MapTrackingStats({
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
    final theme = appColor(context).appTheme;

    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: Card(
        elevation: 4,
        color: theme.bgBox,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(context, Icons.straighten, distance, 'Distance'),
              _buildStatItem(context, Icons.access_time, duration, 'Duration'),
              if (speed != null) _buildStatItem(context, Icons.speed, speed!, 'Speed'),
              if (pointsCount != null)
                _buildStatItem(context, Icons.location_on, '$pointsCount', 'Points'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, IconData icon, String value, String label) {
    final theme = appColor(context).appTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 24, color: theme.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppCss.lexendMedium16.textColor(theme.darkText),
        ),
        Text(
          label,
          style: AppCss.lexendMedium12.textColor(theme.lightText),
        ),
      ],
    );
  }
}
