/// Global app configuration and constants
class MapConfig {
  // Selected tile index (change this to switch map style)
  // 0 = OSM Standard
  // 1 = CartoDB Positron (Light)
  // 2 = CartoDB Dark Matter
  // 3 = Stamen Toner
  // 4 = Stamen Watercolor
  // 5 = Stamen Terrain
  // 6 = OpenTopoMap
  static const int selectedTileIndex = 7;

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
    {
      'name': 'CartoDB Voyager',
      'url':
          'https://a.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
    },
    {
      'name': 'TomTom Basic Main (PNG)',
      'url':
          'https://api.tomtom.com/map/1/tile/basic/main/{z}/{x}/{y}.png?key=WQaLf0lFFvii7Co5xgJ6mawtRRiy3w8G',
    },
    {
      'name': 'TomTom Basic Night (PNG)',
      'url':
          'https://api.tomtom.com/map/1/tile/basic/night/{z}/{x}/{y}.png?key=WQaLf0lFFvii7Co5xgJ6mawtRRiy3w8G',
    },
    {
      'name': 'TomTom Basic Main Lite (Voyager-like)',
      'url':
          'https://api.tomtom.com/map/1/tile/basic/main-lite/{z}/{x}/{y}.png?key=WQaLf0lFFvii7Co5xgJ6mawtRRiy3w8G',
    },
    {
      'name': 'TomTom Basic Main',
      'url':
          'https://api.tomtom.com/map/1/tile/basic/main/{z}/{x}/{y}.png?key=WQaLf0lFFvii7Co5xgJ6mawtRRiy3w8G',
    },
    {
      'name': 'TomTom Labels Main Lite',
      'url':
          'https://api.tomtom.com/map/1/tile/labels/main-lite/{z}/{x}/{y}.png?key=WQaLf0lFFvii7Co5xgJ6mawtRRiy3w8G',
    }
  ];

  // Get selected tile URL
  static String get selectedTileUrl =>
      osmTileOptions[selectedTileIndex]['url']!;

  static const String userAgentPackageName = 'com.pixelstrap.taxify_user_ui';
}
