import '../../config.dart';

/// Map controls overlay widget
/// Provides zoom, location, and layer controls for the map
class MapControls extends StatelessWidget {
  final VoidCallback? onZoomIn;
  final VoidCallback? onZoomOut;
  final VoidCallback? onMyLocation;
  final VoidCallback? onLayers;
  final VoidCallback? onCompass;
  final bool showLayersButton;
  final bool showCompassButton;
  final double buttonSize;
  final double bottom;
  final double right;

  const MapControls({
    super.key,
    this.onZoomIn,
    this.onZoomOut,
    this.onMyLocation,
    this.onLayers,
    this.onCompass,
    this.showLayersButton = false,
    this.showCompassButton = false,
    this.buttonSize = 48,
    this.bottom = 100,
    this.right = 16,
  });

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context).appTheme;

    return Positioned(
      right: right,
      bottom: bottom,
      child: Column(
        children: [
          if (showCompassButton && onCompass != null) ...[
            _buildControlButton(
              context: context,
              icon: Icons.explore,
              onPressed: onCompass,
              theme: theme,
            ),
            const SizedBox(height: 8),
          ],
          if (showLayersButton && onLayers != null) ...[
            _buildControlButton(
              context: context,
              icon: Icons.layers,
              onPressed: onLayers,
              theme: theme,
            ),
            const SizedBox(height: 8),
          ],
          _buildControlButton(
            context: context,
            icon: Icons.add,
            onPressed: onZoomIn,
            theme: theme,
          ),
          const SizedBox(height: 8),
          _buildControlButton(
            context: context,
            icon: Icons.remove,
            onPressed: onZoomOut,
            theme: theme,
          ),
          const SizedBox(height: 8),
          _buildControlButton(
            context: context,
            icon: Icons.my_location,
            onPressed: onMyLocation,
            theme: theme,
            iconColor: theme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required BuildContext context,
    required IconData icon,
    required AppTheme theme,
    VoidCallback? onPressed,
    Color? iconColor,
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
            color: theme.bgBox,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: iconColor ?? theme.darkText,
            size: buttonSize * 0.5,
          ),
        ),
      ),
    );
  }
}

/// Floating action button for map
class MapFloatingButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;
  final String? tooltip;

  const MapFloatingButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size = 56,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context).appTheme;

    return Tooltip(
      message: tooltip ?? '',
      child: Material(
        elevation: 6,
        shape: const CircleBorder(),
        shadowColor: Colors.black38,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: backgroundColor ?? theme.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor ?? Colors.white,
              size: size * 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

/// Bottom action bar for map screens
class MapBottomActionBar extends StatelessWidget {
  final String? primaryLabel;
  final VoidCallback? onPrimaryPressed;
  final IconData? primaryIcon;
  final String? secondaryLabel;
  final VoidCallback? onSecondaryPressed;
  final IconData? secondaryIcon;
  final Widget? leading;

  const MapBottomActionBar({
    super.key,
    this.primaryLabel,
    this.onPrimaryPressed,
    this.primaryIcon,
    this.secondaryLabel,
    this.onSecondaryPressed,
    this.secondaryIcon,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context).appTheme;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.bgBox,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: 12),
              ],
              if (secondaryLabel != null && onSecondaryPressed != null) ...[
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onSecondaryPressed,
                    icon: secondaryIcon != null
                        ? Icon(secondaryIcon, color: theme.primary)
                        : const SizedBox.shrink(),
                    label: Text(
                      secondaryLabel!,
                      style: AppCss.lexendMedium14.textColor(theme.primary),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: theme.primary),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              if (primaryLabel != null && onPrimaryPressed != null)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onPrimaryPressed,
                    icon: primaryIcon != null
                        ? Icon(primaryIcon, color: Colors.white)
                        : const SizedBox.shrink(),
                    label: Text(
                      primaryLabel!,
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
            ],
          ),
        ),
      ),
    );
  }
}

/// Chip selector for map options (e.g., travel mode, route type)
class MapChipSelector<T> extends StatelessWidget {
  final List<MapChipOption<T>> options;
  final T selectedValue;
  final ValueChanged<T> onSelected;
  final bool scrollable;

  const MapChipSelector({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onSelected,
    this.scrollable = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = appColor(context).appTheme;

    final chips = options.map((option) {
      final isSelected = option.value == selectedValue;
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: ChoiceChip(
          avatar: option.icon != null
              ? Icon(
                  option.icon,
                  size: 18,
                  color: isSelected ? Colors.white : theme.primary,
                )
              : null,
          label: Text(option.label),
          selected: isSelected,
          selectedColor: theme.primary,
          labelStyle: AppCss.lexendMedium12.textColor(
            isSelected ? Colors.white : theme.darkText,
          ),
          onSelected: (_) => onSelected(option.value),
        ),
      );
    }).toList();

    if (scrollable) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: chips),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: chips,
    );
  }
}

/// Option for MapChipSelector
class MapChipOption<T> {
  final T value;
  final String label;
  final IconData? icon;

  const MapChipOption({
    required this.value,
    required this.label,
    this.icon,
  });
}
