import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Local Imports
import 'package:vmunimapapp/text_formatting.dart';

class MoreInfoPage extends StatefulWidget {
  final String selectedBuildingID;
  const MoreInfoPage({super.key, required this.selectedBuildingID});

  @override
  State<MoreInfoPage> createState() => _MoreInfoPageState();
}

class Item {
  String expandedValue;
  String headerValue;
  bool isExpanded;
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });
}

class _MoreInfoPageState extends State<MoreInfoPage> {
  late final Future<Map<String, dynamic>> buildingDataFuture;
  final Map<String, bool> _expandedStates = {};

  @override
  void initState() {
    super.initState();
    buildingDataFuture =
        _initialize()..then((data) {
          // Populate the map once we know how many categories there are:
          final keys = (data['categories'] as Map).keys;
          for (var k in keys) {
            _expandedStates[k] = false;
          }
          setState(() {}); // trigger a rebuild now that our map is ready
        });
  }

  Future<Map<String, dynamic>> _initialize() async {
    try {
      final String jsonFile = 'assets/json/map_info.json';
      final jsonData = jsonDecode(await rootBundle.loadString(jsonFile));
      final buildingInfo = jsonData['map_objects'][widget.selectedBuildingID];

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

        final Map<String, dynamic> data = snapshot.data!;
        final List category = data['categories'].keys.toList();

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(data['name']!, style: titleText),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                    child: Center(
                      child: Image.asset(
                        'assets/images/buildings/${widget.selectedBuildingID}.webp',
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset('assets/images/vmuf.webp');
                        },
                      ),
                    ),
                  ),

                  // Text(data['description']!),
                  ExpansionPanelList(
                    expansionCallback: (i, isExpanded) {
                      final index = category[i];
                      setState(() {
                        _expandedStates[index] = isExpanded;
                      });
                    },
                    children: [
                      for (var i = 0; i < category.length; i++)
                        ExpansionPanel(
                          // Categories
                          headerBuilder:
                              (ctx, isExp) => Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  capitalize(category[i]),
                                  style: headerText,
                                ),
                              ),
                          body: Column(
                            children: [
                              for (var property
                                  in data['categories'][category[i]].keys)
                                ListTile(
                                  title: Text('$property', style: propertyText),
                                  subtitle: Column(
                                    children: [
                                      for (var info
                                          in data['categories'][category[i]][property]
                                              .keys)
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            '${data['categories'][category[i]][property][info]}',
                                          ),
                                        ),
                                      if (data['categories'][category[i]]
                                              .length >
                                          1)
                                        const Divider(),
                                    ],
                                  ),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder:
                                          (context) => FittedBox(
                                            child: AlertDialog(
                                              content: InteractiveViewer(
                                                constrained: true,
                                                minScale: 0.5,
                                                maxScale: 3.0,
                                                child: Image.asset(
                                                  'assets/images/rooms/${widget.selectedBuildingID}/$property.webp',
                                                  filterQuality:
                                                      FilterQuality.medium,
                                                  isAntiAlias: true,
                                                  errorBuilder: (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) {
                                                    return Image.asset(
                                                      'assets/images/vmuf.webp',
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                    );
                                  },
                                ),
                            ],
                          ),
                          isExpanded: _expandedStates[category[i]]!,
                          canTapOnHeader: true,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
