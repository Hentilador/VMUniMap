import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Local Imports
import 'package:vmunimapapp/more_info_screen.dart';
import 'package:vmunimapapp/text_formatting.dart';

class InfoSheet extends StatelessWidget {
  final String selectedBuildingID;

  InfoSheet({super.key, required this.selectedBuildingID});

  late final Future<Map<String, dynamic>> buildingDataFuture = _initialize();

  Future<Map<String, dynamic>> _initialize() async {
    try {
      final String jsonFile = 'assets/json/map_info.json';
      final jsonData = jsonDecode(await rootBundle.loadString(jsonFile));
      final buildingInfo = jsonData['map_objects'][selectedBuildingID];

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
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data!;

        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InteractiveViewer(
                      constrained: true,
                      minScale: 0.5,
                      maxScale: 3.0,
                      child: Image.asset(
                        'assets/images/buildings/$selectedBuildingID.webp',
                        filterQuality: FilterQuality.medium,
                        isAntiAlias: true,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset('assets/images/vmuf.webp');
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(data['name']!, style: titleText),
                          SizedBox(height: 12),
                          Text(data['description']!),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if ((data['categories'] as Map).isNotEmpty) ...[
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
