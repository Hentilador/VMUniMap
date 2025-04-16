import 'package:flutter/material.dart';
import 'package:vmunimapapp/info_sheet.dart';
import 'package:vmunimapapp/map_widget.dart';
import 'package:vmunimapapp/painting.dart';
import 'package:vmunimapapp/text_formatting.dart';
import 'package:color_scheme_display/color_scheme_display.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CampusMapData? mapData;
  String? selectedBuildingID;

  bool isLoading = true;
  // For navigation bar
  int _currentPageIndex = 0;
  // final List<Widget> _pages = [];
  final List<Widget> _listOfDestinations = const [
    NavigationDestination(icon: Icon(Icons.map), label: 'Map'),
    NavigationDestination(icon: Icon(Icons.palette), label: 'Colors'),
  ];

  @override
  void initState() {
    super.initState();
    _loadSvgData();
  }

  Future<void> _loadSvgData() async {
    try {
      final data = await loadCampusMap();
      setState(() {
        mapData = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading SVG: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onBuildingTapped(String buildingId, String buildingName) {
    setState(() {
      // Toggle selection - if already selected, deselect it
      selectedBuildingID =
          buildingId; //buildingId == selectedBuildingID ? null :
    });

    // Show building info if a building is selected
    if (selectedBuildingID != null) {
      showModalBottomSheet(
        context: context,
        builder:
            (ctx) => InfoSheet(
              selectedBuildingID: buildingId,
              buildingName: buildingName,
            ),
        showDragHandle: false,
        isScrollControlled: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VMUniMap', style: titleText),
        centerTitle: false,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentPageIndex,
        destinations: _listOfDestinations,
        onDestinationSelected: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_currentPageIndex == 1) {
      return ColorSchemeDisplay();
    }

    // Map page
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (mapData == null || mapData!.buildings.isEmpty) {
      return const Center(child: Text('No buildings found in SVG file'));
    }

    return InteractiveViewer(
      boundaryMargin: const EdgeInsets.all(20.0),
      minScale: 1.11,
      maxScale: 3.33,
      child: Center(
        child: CampusMapWidget(
          mapData: mapData!,
          onBuildingSelected: _onBuildingTapped,
          selectedBuildingID: selectedBuildingID,
          strokeColor: Colors.black,
          strokeWidth: 1.0,
        ),
      ),
    );
  }
}
