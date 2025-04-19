import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vmunimapapp/text_formatting.dart';

class Sidebar extends StatefulWidget {
  final Function(String) onBuildingSelected;
  final TransformationController transformationController;

  const Sidebar({
    super.key,
    required this.onBuildingSelected,
    required this.transformationController,
  });

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  late Future<Map<String, dynamic>> _mapDataFuture;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<MapItem> _filteredItems = [];
  List<MapItem> _allItems = [];

  @override
  void initState() {
    super.initState();
    _mapDataFuture = _loadMapData();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      _filterItems();
    });
  }

  void _filterItems() {
    if (_searchQuery.isEmpty) {
      _filteredItems = List.from(_allItems);
    } else {
      _filteredItems =
          _allItems
              .where(
                (item) =>
                    item.name.toLowerCase().contains(_searchQuery) ||
                    (item.category?.toLowerCase().contains(_searchQuery) ??
                        false) ||
                    (item.subcategory?.toLowerCase().contains(_searchQuery) ??
                        false),
              )
              .toList();
    }
  }

  Future<Map<String, dynamic>> _loadMapData() async {
    try {
      final String jsonFile = 'assets/json/map_info.json';
      final jsonData = jsonDecode(await rootBundle.loadString(jsonFile));
      _processMapData(jsonData);
      return jsonData;
    } catch (e) {
      print('Error loading map data: $e');
      return {};
    }
  }

  void _processMapData(Map<String, dynamic> data) {
    _allItems = [];

    final buildings = data['map_objects'] as Map<String, dynamic>;

    // Add all buildings first
    buildings.forEach((buildingId, buildingData) {
      final building = MapItem(
        id: buildingId,
        name: buildingData['name'],
        type: ItemType.building,
      );
      _allItems.add(building);

      // Then add all categories and their items
      final categories =
          buildingData['categories'] as Map<String, dynamic>? ?? {};
      categories.forEach((categoryName, categoryContent) {
        // Only add category items if there are any
        if (categoryContent is Map && categoryContent.isNotEmpty) {
          // Add a category header item
          final categoryItem = MapItem(
            id: buildingId,
            name: capitalize(categoryName),
            type: ItemType.category,
            subcategory: buildingData['name'],
          );
          _allItems.add(categoryItem);

          // Add individual items in this category
          categoryContent.forEach((itemName, itemDetails) {
            final item = MapItem(
              id: buildingId, // Still reference the parent building ID
              name: itemName,
              type: ItemType.location,
              category: capitalize(categoryName),
              subcategory: buildingData['name'],
              details:
                  itemDetails is Map
                      ? itemDetails.cast<String, dynamic>()
                      : null,
            );
            _allItems.add(item);
          });
        }
      });
    });

    _filteredItems = List.from(_allItems);
  }

  void _handleItemTap(MapItem item) {
    // Close the drawer
    Navigator.pop(context);

    // Call the callback function with the building ID
    widget.onBuildingSelected(item.id);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: Image.asset('assets/images/default.jpg').image,
                fit: BoxFit.cover,
              ),
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'VMUniMap Directory',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Buildings & Places',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 12,
                ),
              ),
            ),
          ),
          FutureBuilder<Map<String, dynamic>>(
            future: _mapDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError || !snapshot.hasData) {
                return const Center(child: Text('Error loading map data'));
              }

              if (_filteredItems.isEmpty) {
                return const Expanded(
                  child: Center(child: Text('No results found')),
                );
              }

              return Expanded(
                child: ListView.builder(
                  itemCount: _filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = _filteredItems[index];

                    // Different UI for different item types
                    if (item.type == ItemType.category) {
                      // Category header
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                        child: Text(
                          item.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      );
                    }

                    // Building or location item
                    return ListTile(
                      leading: Icon(_getIconForItemType(item.type)),
                      title: Text(item.name),
                      subtitle:
                          item.type == ItemType.location
                              ? Text('in ${item.subcategory}')
                              : null,
                      tileColor:
                          item.type == ItemType.building
                              ? Theme.of(
                                context,
                              ).colorScheme.surfaceVariant.withOpacity(0.3)
                              : null,
                      onTap: () => _handleItemTap(item),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  IconData _getIconForItemType(ItemType type) {
    switch (type) {
      case ItemType.building:
        return Icons.apartment;
      case ItemType.location:
        return Icons.place;
      case ItemType.category:
        return Icons.category;
    }
  }
}

// Model classes for map items
enum ItemType { building, location, category }

class MapItem {
  final String id;
  final String name;
  final ItemType type;
  final String? category;
  final String? subcategory;
  final Map<String, dynamic>? details;

  MapItem({
    required this.id,
    required this.name,
    required this.type,
    this.category,
    this.subcategory,
    this.details,
  });
}
