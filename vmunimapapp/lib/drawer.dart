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

  // List of categories or items to exclude from the drawer
  final List<String> _excludedItems = [
    'restroom',
    'restrooms',
    'bathroom',
    'bathrooms',
    'toilet',
    'toilets',
  ];

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

    // First, add all buildings
    final buildings = data['map_objects'] as Map<String, dynamic>;

    // Add all buildings first
    buildings.forEach((buildingId, buildingData) {
      final building = MapItem(
        id: buildingId,
        name: buildingData['name'],
        type: ItemType.building,
      );
      _allItems.add(building);
    });

    // For grouped categories, we'll collect all items by category first
    final Map<String, List<MapItem>> categorizedItems = {};

    // Process all buildings and collect items by category
    buildings.forEach((buildingId, buildingData) {
      final buildingName = buildingData['name'];
      final categories =
          buildingData['categories'] as Map<String, dynamic>? ?? {};

      categories.forEach((categoryName, categoryContent) {
        // Skip excluded categories
        if (_shouldExcludeCategory(categoryName)) {
          return;
        }

        if (categoryContent is Map && categoryContent.isNotEmpty) {
          // Filter out excluded items
          final filteredContent = Map<String, dynamic>.from(categoryContent)
            ..removeWhere((itemName, _) => _shouldExcludeItem(itemName));

          if (filteredContent.isEmpty) {
            return;
          }

          // Initialize category list if it doesn't exist
          final normalizedCategoryName = _normalizeCategoryName(categoryName);
          categorizedItems.putIfAbsent(normalizedCategoryName, () => []);

          // Add items to this category
          filteredContent.forEach((itemName, itemDetails) {
            final item = MapItem(
              id: buildingId,
              name: itemName,
              type: ItemType.location,
              category: capitalize(normalizedCategoryName),
              subcategory: buildingName,
              details:
                  itemDetails is Map
                      ? itemDetails.cast<String, dynamic>()
                      : null,
            );

            categorizedItems[normalizedCategoryName]!.add(item);
          });
        }
      });
    });

    // Now add all categories and their items to _allItems
    final sortedCategories = categorizedItems.keys.toList()..sort();

    for (final categoryName in sortedCategories) {
      // Skip if the category has no items after filtering
      if (categorizedItems[categoryName]!.isEmpty) {
        continue;
      }

      // Add category header
      _allItems.add(
        MapItem(
          id: 'category_$categoryName',
          name: capitalize(categoryName),
          type: ItemType.category,
        ),
      );

      // Sort items within category by name
      final items = categorizedItems[categoryName]!;
      items.sort((a, b) => a.name.compareTo(b.name));

      // Add all items for this category
      _allItems.addAll(items);
    }

    _filteredItems = List.from(_allItems);
  }

  // Helper method to normalize category names (e.g., "Office", "Offices" -> "Offices")
  String _normalizeCategoryName(String categoryName) {
    final lowerName = categoryName.toLowerCase();

    // Add your normalization rules here
    if (lowerName == 'office') return 'offices';
    if (lowerName == 'classroom') return 'classrooms';
    if (lowerName == 'laboratory') return 'laboratories';
    if (lowerName == 'lab') return 'laboratories';
    if (lowerName == 'facility') return 'facilities';

    return categoryName;
  }

  // Helper method to check if a category should be excluded
  bool _shouldExcludeCategory(String categoryName) {
    final lowerCaseName = categoryName.toLowerCase();
    return _excludedItems.any((item) => lowerCaseName.contains(item));
  }

  // Helper method to check if an item should be excluded
  bool _shouldExcludeItem(String itemName) {
    final lowerCaseName = itemName.toLowerCase();
    return _excludedItems.any((item) => lowerCaseName.contains(item));
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
          DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              image: DecorationImage(image: Image.asset('assets/images/vmuf.webp').image, fit: BoxFit.contain),
            ),
            child: Align(alignment: Alignment.bottomLeft,
            child: SizedBox(height: 200,),)
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
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