/// TomTom Maps Configuration
/// Central configuration for TomTom map tile providers and API settings
class TomTomConfig {
  // TomTom API Key
  static const String apiKey = 'WQaLf0lFFvii7Co5xgJ6mawtRRiy3w8G';

  // Selected tile index (change this to switch map style)
  // 0 = Basic Main
  // 1 = Basic Night
  // 2 = Hybrid Main
  // 3 = Hybrid Night
  // 4 = Labels Main
  // 5 = Labels Night
  static const int selectedTileIndex = 0;

  // TomTom tile servers with different styles
  static const List<Map<String, String>> allTileOptions = [
    {
      'name': 'Basic Main',
      'url':
          'https://api.tomtom.com/map/1/tile/basic/main/{z}/{x}/{y}.png?key=$apiKey',
      'description': 'Standard daytime map style',
    },
    {
      'name': 'Basic Night',
      'url':
          'https://api.tomtom.com/map/1/tile/basic/night/{z}/{x}/{y}.png?key=$apiKey',
      'description': 'Dark theme for night mode',
    },
    {
      'name': 'Hybrid Main',
      'url':
          'https://api.tomtom.com/map/1/tile/hybrid/main/{z}/{x}/{y}.png?key=$apiKey',
      'description': 'Satellite with labels overlay',
    },
    {
      'name': 'Hybrid Night',
      'url':
          'https://api.tomtom.com/map/1/tile/hybrid/night/{z}/{x}/{y}.png?key=$apiKey',
      'description': 'Satellite with night labels',
    },
    {
      'name': 'Labels Main',
      'url':
          'https://api.tomtom.com/map/1/tile/labels/main/{z}/{x}/{y}.png?key=$apiKey',
      'description': 'Labels only overlay',
    },
    {
      'name': 'Labels Night',
      'url':
          'https://api.tomtom.com/map/1/tile/labels/night/{z}/{x}/{y}.png?key=$apiKey',
      'description': 'Night labels overlay',
    },
  ];

  // Get selected tile URL
  static String get selectedTileUrl => allTileOptions[selectedTileIndex]['url']!;

  // Get selected tile name
  static String get selectedTileName =>
      allTileOptions[selectedTileIndex]['name']!;

  // User agent for tile requests
  static const String userAgentPackageName = 'com.pingparent.app';

  // Default map settings
  static const double defaultZoom = 15.0;
  static const double minZoom = 3.0;
  static const double maxZoom = 22.0;

  // Default location (can be changed based on app region)
  static const double defaultLatitude = 37.7749;
  static const double defaultLongitude = -122.4194;

  // TomTom Routing API base URL
  static const String routingBaseUrl = 'https://api.tomtom.com/routing/1';

  // TomTom Search API base URL (for geocoding)
  static const String searchBaseUrl = 'https://api.tomtom.com/search/2';

  // TomTom Traffic API base URL
  static const String trafficBaseUrl = 'https://api.tomtom.com/traffic/services/4';
}
