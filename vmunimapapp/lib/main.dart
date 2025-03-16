import 'package:flutter/material.dart';

import 'painting.dart';
import 'theming.dart' show theme;

void main() => runApp(const VMUniMapApp());

// ----------------------------------------
class VMUniMapApp extends StatelessWidget {
  const VMUniMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'VMUniMapApp', home: CampusMap(), theme: theme);
  }
}

class CampusMap extends StatefulWidget {
  const CampusMap({super.key});

  final String svgFilePath = r'assets/svg/vmunimap.svg';

  @override
  State<CampusMap> createState() => _CampusMapState();
}

class _CampusMapState extends State<CampusMap> {
  @override
  void initState() {
    super.initState();
    initialize();
  }

  List<Building> listOfBuildings = [];
  bool isLoading = true;

  Future<void> initialize() async {
    try {
      final document = await loadSvgAsset(widget.svgFilePath);
      setState(() {
        listOfBuildings = Building.fromDocument(document);
        isLoading = false;
      });
    } catch (e) {
      print('Error loading SVG: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // ignore: unused_field
  final TransformationController _transformationController =
      TransformationController();
  // ignore: unused_field
  String? _selectedBuildingID;

  int _currentPageIndex = 0;
  final List<Widget> _listOfDestinations = [
    NavigationDestination(icon: Icon(Icons.map), label: 'Map'),
    NavigationDestination(icon: Icon(Icons.info), label: 'Info'),
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tite')),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        selectedIndex: _currentPageIndex,
        destinations: _listOfDestinations,
      ),

      body: Placeholder(),
    );
  }
}
