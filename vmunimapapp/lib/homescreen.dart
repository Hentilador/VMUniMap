import 'package:color_scheme_display/color_scheme_display.dart';
import 'package:flutter/material.dart';
import 'package:vmunimapapp/info_sheet.dart';
import 'package:vmunimapapp/map_widget.dart';
import 'package:vmunimapapp/painting.dart';
import 'package:vmunimapapp/text_formatting.dart';

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
    _initialize();
  }

  Future<void> _initialize() async {
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
        enableDrag: false,
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
      drawer: _buildDrawer(),
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

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: Image.asset('assets/images/default.jpg').image,
                fit: BoxFit.cover,
              ),
              color: Theme.of(context).colorScheme.primary,
            ),
            child: null,
          ),
        ],
      ),
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
      minScale: 1.23,
      maxScale: 10,
      clipBehavior: Clip.none,
      child: Center(
        child: CampusMapWidget(
          mapData: mapData!,
          onBuildingSelected: _onBuildingTapped,
          selectedBuildingID: selectedBuildingID,
          strokeColor: Colors.black,
        ),
      ),
    );
  }
}
