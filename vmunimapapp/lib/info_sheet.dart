// External Imports
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Local Imports
import 'package:vmunimapapp/more_info_screen.dart';
import 'package:vmunimapapp/text_formatting.dart';

/// A widget that displays information about a building in a bottom sheet.
class InfoSheet extends StatelessWidget {
  /// The ID of the building to be displayed.
  final String selectedBuildingID;

  /// Creates a new instance of [InfoSheet].
  InfoSheet({super.key, required this.selectedBuildingID});

  /// A future that resolves to the data of the building with [selectedBuildingID].
  late final Future<Map<String, dynamic>> buildingDataFuture = _initialize();

  /// Initializes the building data by loading it from the JSON file.
  Future<Map<String, dynamic>> _initialize() async {
    try {
      // Load the JSON file
      final String jsonFile = 'assets/json/map_info.json';
      final jsonData = jsonDecode(await rootBundle.loadString(jsonFile));

      // Get the building info from the JSON data
      final buildingInfo = jsonData['map_objects'][selectedBuildingID];

      // Return the building info as a map
      return {
        'name': buildingInfo['name'] ?? 'Unknown Building',
        'description': buildingInfo['description'] ?? '',
        'categories': buildingInfo['categories'] ?? {},
      };
    } catch (e) {
      print('Error loading building data: $e');
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: buildingDataFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // Show a loading indicator if the data is not yet available
          return const Center(child: CircularProgressIndicator());
        }

        // Get the building data from the snapshot
        final data = snapshot.data!;

        // Build the UI for the info sheet
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display the building image
                    InteractiveViewer(
                      constrained: true,
                      minScale: 0.5,
                      maxScale: 3.0,
                      child: Image.asset(
                        'assets/images/buildings/$selectedBuildingID.webp',
                        filterQuality: FilterQuality.medium,
                        isAntiAlias: true,
                        errorBuilder: (context, error, stackTrace) {
                          // Display the default image if the image is not found
                          return Image.asset('assets/images/vmuf.webp');
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Display the building name and description
                          Text(data['name']!, style: titleText),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                            child: Text(data['description']!),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if ((data['categories'] as Map).isNotEmpty) ...[
                // Display a button to show more information if the categories is not empty
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => MoreInfoPage(
                              selectedBuildingID: selectedBuildingID,
                            ),
                      ),
                    );
                  },
                  child: Text('More info'),
                ),
                SizedBox(height: 12),
              ],
            ],
          ),
        );
      },
    );
  }
}
