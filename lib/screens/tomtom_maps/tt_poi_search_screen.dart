import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../../common/tomtom_config.dart';

/// TomTom POI Search Screen
/// Demonstrates TomTom's premium Points of Interest search
/// Including nearby search, category search, and detailed POI info
class TTPoiSearchScreen extends StatefulWidget {
  const TTPoiSearchScreen({super.key});

  @override
  State<TTPoiSearchScreen> createState() => _TTPoiSearchScreenState();
}

class _TTPoiSearchScreenState extends State<TTPoiSearchScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  double _currentZoom = 14.0;
  LatLng _center = const LatLng(37.7749, -122.4194);

  List<PoiResult> _searchResults = [];
  PoiResult? _selectedPoi;
  bool _isLoading = false;
  bool _showSearchResults = false;

  // Category quick filters
  final List<Map<String, dynamic>> _categories = [
    {'id': '7315', 'name': 'Restaurant', 'icon': Icons.restaurant},
    {'id': '7376', 'name': 'Cafe', 'icon': Icons.coffee},
    {'id': '7311', 'name': 'Gas Station', 'icon': Icons.local_gas_station},
    {'id': '7332', 'name': 'Parking', 'icon': Icons.local_parking},
    {'id': '9663', 'name': 'ATM', 'icon': Icons.atm},
    {'id': '7373', 'name': 'Pharmacy', 'icon': Icons.local_pharmacy},
    {'id': '9352', 'name': 'Supermarket', 'icon': Icons.shopping_cart},
    {'id': '7314', 'name': 'Hotel', 'icon': Icons.hotel},
  ];

  String? _activeCategory;

  Future<void> _searchPoi(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _showSearchResults = true;
      _activeCategory = null;
    });

    try {
      final url =
          '${TomTomConfig.searchBaseUrl}/search/$query.json'
          '?key=${TomTomConfig.apiKey}'
          '&lat=${_center.latitude}'
          '&lon=${_center.longitude}'
          '&radius=10000'
          '&limit=20'
          '&language=en-US';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = <PoiResult>[];

        if (data['results'] != null) {
          for (final result in data['results']) {
            results.add(PoiResult.fromJson(result));
          }
        }

        setState(() {
          _searchResults = results;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _searchByCategory(String categoryId, String categoryName) async {
    setState(() {
      _isLoading = true;
      _showSearchResults = true;
      _activeCategory = categoryId;
      _searchController.text = categoryName;
    });

    try {
      final url =
          '${TomTomConfig.searchBaseUrl}/categorySearch/$categoryId.json'
          '?key=${TomTomConfig.apiKey}'
          '&lat=${_center.latitude}'
          '&lon=${_center.longitude}'
          '&radius=5000'
          '&limit=20'
          '&language=en-US';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = <PoiResult>[];

        if (data['results'] != null) {
          for (final result in data['results']) {
            results.add(PoiResult.fromJson(result));
          }
        }

        setState(() {
          _searchResults = results;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Marker> _buildPoiMarkers() {
    return _searchResults.map((poi) {
      final isSelected = _selectedPoi?.id == poi.id;
      return Marker(
        point: poi.location,
        width: isSelected ? 50 : 40,
        height: isSelected ? 50 : 40,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _selectedPoi = poi;
              _showSearchResults = false;
            });
            _mapController.move(poi.location, _currentZoom);
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue : Colors.red,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: isSelected ? 3 : 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Icon(
              poi.categoryIcon,
              color: Colors.white,
              size: isSelected ? 24 : 20,
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('POI Search'),
        backgroundColor: Colors.purple.shade700,
        foregroundColor: Colors.white,
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
              onTap: (_, __) => setState(() {
                _selectedPoi = null;
                _showSearchResults = false;
              }),
              onPositionChanged: (position, hasGesture) {
                _currentZoom = position.zoom;
                _center = position.center;
              },
            ),
            children: [
              TileLayer(
                urlTemplate: TomTomConfig.allTileOptions[0]['url']!,
                userAgentPackageName: TomTomConfig.userAgentPackageName,
              ),
              MarkerLayer(markers: _buildPoiMarkers()),
            ],
          ),
          // Search bar
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Column(
              children: [
                Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(12),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search places...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchResults = [];
                                  _showSearchResults = false;
                                  _activeCategory = null;
                                });
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onSubmitted: _searchPoi,
                  ),
                ),
                const SizedBox(height: 8),
                // Category chips
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isActive = _activeCategory == category['id'];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          avatar: Icon(
                            category['icon'],
                            size: 18,
                            color: isActive ? Colors.white : Colors.purple,
                          ),
                          label: Text(category['name']),
                          selected: isActive,
                          selectedColor: Colors.purple,
                          labelStyle: TextStyle(
                            color: isActive ? Colors.white : Colors.black,
                          ),
                          onSelected: (_) => _searchByCategory(
                            category['id'],
                            category['name'],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Loading indicator
          if (_isLoading)
            Positioned(
              top: 130,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 12),
                      Text('Searching...'),
                    ],
                  ),
                ),
              ),
            ),
          // Search results list
          if (_showSearchResults && _searchResults.isNotEmpty && !_isLoading)
            Positioned(
              top: 130,
              left: 16,
              right: 16,
              bottom: 100,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Text(
                              '${_searchResults.length} results',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () =>
                                  setState(() => _showSearchResults = false),
                              child: const Text('Show on map'),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            final poi = _searchResults[index];
                            return ListTile(
                              leading: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.purple.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  poi.categoryIcon,
                                  color: Colors.purple,
                                ),
                              ),
                              title: Text(
                                poi.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                poi.address,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              trailing: poi.distance != null
                                  ? Text(
                                      poi.formattedDistance,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    )
                                  : null,
                              onTap: () {
                                setState(() {
                                  _selectedPoi = poi;
                                  _showSearchResults = false;
                                });
                                _mapController.move(poi.location, 16);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          // Selected POI details
          if (_selectedPoi != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildPoiDetailsCard(_selectedPoi!),
            ),
          // Zoom controls
          Positioned(
            right: 16,
            bottom: _selectedPoi != null ? 200 : 100,
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

  Widget _buildPoiDetailsCard(PoiResult poi) {
    return Material(
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
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      poi.categoryIcon,
                      color: Colors.purple,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          poi.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        if (poi.categoryNames.isNotEmpty)
                          Text(
                            poi.categoryNames.join(' • '),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(() => _selectedPoi = null),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.location_on, poi.address),
              if (poi.phone != null) _buildInfoRow(Icons.phone, poi.phone!),
              if (poi.url != null) _buildInfoRow(Icons.language, poi.url!),
              if (poi.distance != null)
                _buildInfoRow(Icons.straighten, poi.formattedDistance),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Navigate to routing screen with this POI as destination
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Navigate to this location'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.directions, color: Colors.white),
                      label: const Text(
                        'Directions',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// POI result data model
class PoiResult {
  final String id;
  final String name;
  final String address;
  final LatLng location;
  final double? distance;
  final String? phone;
  final String? url;
  final List<String> categoryNames;
  final String? categoryId;

  PoiResult({
    required this.id,
    required this.name,
    required this.address,
    required this.location,
    this.distance,
    this.phone,
    this.url,
    this.categoryNames = const [],
    this.categoryId,
  });

  factory PoiResult.fromJson(Map<String, dynamic> json) {
    final poi = json['poi'] ?? {};
    final address = json['address'] ?? {};
    final position = json['position'] ?? {};

    final categoryNames = <String>[];
    if (poi['categories'] != null) {
      for (final cat in poi['categories']) {
        categoryNames.add(cat.toString());
      }
    }

    String? categoryId;
    if (poi['categorySet'] != null && (poi['categorySet'] as List).isNotEmpty) {
      categoryId = poi['categorySet'][0]['id']?.toString();
    }

    return PoiResult(
      id: json['id'] ?? '',
      name: poi['name'] ?? address['freeformAddress'] ?? 'Unknown',
      address: address['freeformAddress'] ?? '',
      location: LatLng(
        position['lat']?.toDouble() ?? 0.0,
        position['lon']?.toDouble() ?? 0.0,
      ),
      distance: json['dist']?.toDouble(),
      phone: poi['phone'],
      url: poi['url'],
      categoryNames: categoryNames,
      categoryId: categoryId,
    );
  }

  String get formattedDistance {
    if (distance == null) return '';
    if (distance! >= 1000) {
      return '${(distance! / 1000).toStringAsFixed(1)} km';
    }
    return '${distance!.round()} m';
  }

  IconData get categoryIcon {
    final name = categoryNames.join(' ').toLowerCase();
    if (name.contains('restaurant') || name.contains('food')) {
      return Icons.restaurant;
    }
    if (name.contains('cafe') || name.contains('coffee')) {
      return Icons.coffee;
    }
    if (name.contains('gas') || name.contains('fuel') || name.contains('petrol')) {
      return Icons.local_gas_station;
    }
    if (name.contains('parking')) {
      return Icons.local_parking;
    }
    if (name.contains('atm') || name.contains('bank')) {
      return Icons.atm;
    }
    if (name.contains('pharmacy') || name.contains('drug')) {
      return Icons.local_pharmacy;
    }
    if (name.contains('supermarket') || name.contains('grocery')) {
      return Icons.shopping_cart;
    }
    if (name.contains('hotel') || name.contains('lodging')) {
      return Icons.hotel;
    }
    if (name.contains('hospital') || name.contains('medical')) {
      return Icons.local_hospital;
    }
    if (name.contains('school') || name.contains('education')) {
      return Icons.school;
    }
    return Icons.place;
  }
}
