/// Global app configuration and constants
class MapConfig {
  // List of available OSM tile servers
  static const List<Map<String, String>> osmTileOptions = [
    {
      'name': 'OSM Standard',
      'url': 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    },
    {
      'name': 'CartoDB Positron (Light)',
      'url': 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
    },
    {
      'name': 'CartoDB Dark Matter',
      'url': 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
    },
    {
      'name': 'Stamen Toner',
      'url': 'https://stamen-tiles.a.ssl.fastly.net/toner/{z}/{x}/{y}.png',
    },
    {
      'name': 'Stamen Watercolor',
      'url': 'https://stamen-tiles.a.ssl.fastly.net/watercolor/{z}/{x}/{y}.jpg',
    },
    {
      'name': 'Stamen Terrain',
      'url': 'https://stamen-tiles.a.ssl.fastly.net/terrain/{z}/{x}/{y}.jpg',
    },
    {
      'name': 'OpenTopoMap',
      'url': 'https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png',
    },
    // Add more as needed
  ];

  static const String userAgentPackageName = 'com.pixelstrap.taxify_user_ui';
}
