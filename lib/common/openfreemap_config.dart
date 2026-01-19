/// OpenFreeMap Configuration
/// Central configuration for free map tile providers and settings
class OpenFreeMapConfig {
  // Selected tile index (change this to switch map style)
  // 0 = OSM Standard
  // 1 = CartoDB Positron (Light)
  // 2 = CartoDB Dark Matter
  // 3 = CartoDB Voyager
  // 4 = OpenTopoMap
  // 5 = Stadia Alidade Smooth
  static const int selectedTileIndex = 1;

  // Free OSM-based tile servers (all free, no API key required)
  static const List<Map<String, String>> allTileOptions = [
    {
      'name': 'OSM Standard',
      'url': 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      'description': 'Classic OpenStreetMap style',
    },
    {
      'name': 'CartoDB Positron (Light)',
      'url': 'https://a.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
      'description': 'Clean light theme - recommended',
    },
    {
      'name': 'CartoDB Dark Matter',
      'url': 'https://a.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
      'description': 'Dark theme for night mode',
    },
    {
      'name': 'CartoDB Voyager',
      'url': 'https://a.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
      'description': 'Colorful, detailed style',
    },
    {
      'name': 'OpenTopoMap',
      'url': 'https://a.tile.opentopomap.org/{z}/{x}/{y}.png',
      'description': 'Topographic map style',
    },
    {
      'name': 'Stadia Alidade Smooth',
      'url': 'https://tiles.stadiamaps.com/tiles/alidade_smooth/{z}/{x}/{y}.png',
      'description': 'Modern smooth style',
    },
  ];

  // Get selected tile URL
  static String get selectedTileUrl => allTileOptions[selectedTileIndex]['url']!;

  // Get selected tile name
  static String get selectedTileName =>
      allTileOptions[selectedTileIndex]['name']!;

  // User agent for tile requests (required by some providers)
  static const String userAgentPackageName = 'com.pingparent.app';

  // Default map settings
  static const double defaultZoom = 15.0;
  static const double minZoom = 3.0;
  static const double maxZoom = 19.0;

  // Default location (can be changed based on app region)
  static const double defaultLatitude = 37.7749;
  static const double defaultLongitude = -122.4194;

  // OSRM routing server (free, no API key needed)
  static const String osrmBaseUrl = 'https://router.project-osrm.org';

  // Nominatim geocoding server (free, no API key needed)
  static const String nominatimBaseUrl = 'https://nominatim.openstreetmap.org';
}
