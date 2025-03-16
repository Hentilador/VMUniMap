import 'package:flutter/material.dart';
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

  @override
  State<CampusMap> createState() => _CampusMapState();
}

class _CampusMapState extends State<CampusMap> {
  static int currentPageIndex = 0;

  List<Widget> listOfDestinations = [
    NavigationDestination(icon: Icon(Icons.map), label: 'Map'),
    NavigationDestination(icon: Icon(Icons.info), label: 'Info'),
  ];
// 
  String svgMapFilePath = r'assets/svg/vmunimap.svg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('VMUniMap')),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: listOfDestinations,
      ),
    );
  }
}
