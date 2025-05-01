// External Imports
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
// Local Imports
import 'package:vmunimapapp/drawer.dart';
import 'package:vmunimapapp/info_sheet.dart';
import 'package:vmunimapapp/map_widget.dart';
import 'package:vmunimapapp/more_info_screen.dart';
import 'package:vmunimapapp/svg_parsing.dart';
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

  int _currentPageIndex = 0; // For navigation bar

  // final List<Widget> _pages = [];
  final List<Widget> _listOfDestinations = const [
    NavigationDestination(icon: Icon(Icons.map), label: 'Map'),
    NavigationDestination(icon: Icon(Icons.info), label: 'About'),
  ];
  final TransformationController _transformationController =
      TransformationController();

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

  dynamic _onBuildingSelected(String buildingId) {
    setState(() {
      // Toggle selection - if already selected, deselect it
      selectedBuildingID = buildingId;
      //buildingId == selectedBuildingID ? null :
    });

    if (selectedBuildingID != null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) =>
          MoreInfoPage(selectedBuildingID: buildingId)));
    }
    // _zoomToBuilding(buildingId);
  }

  dynamic _onBuildingTapped(String buildingId) {
    setState(() {
      // Toggle selection - if already selected, deselect it
      selectedBuildingID = buildingId;
      //buildingId == selectedBuildingID ? null :
    });

    // Show building info if a building is selected
    if (selectedBuildingID != null) {
      showModalBottomSheet(
        context: context,
        builder: (ctx) => InfoSheet(selectedBuildingID: buildingId),
        showDragHandle: true,
        isScrollControlled: true,
        enableDrag: true,
      );
    }
  }

  // void _zoomToBuilding(String buildingId) {

  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/vmuf.webp', height: 45),
            const SizedBox(width: 8),
            Text('VMUniMap', style: titleText),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.school),
            onPressed: () async {
              final Uri url = Uri.parse('https://vmuf.edu.ph/');
              if (!await launchUrl(url)) {
                throw ('Could not launch $url');
              }
            },
          ),
        ],
      ),
      drawer: Sidebar(
        onBuildingSelected:
            _onBuildingSelected,
        transformationController: _transformationController,
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
      // return ColorSchemeDisplay();
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/cics.webp', height: 150),
              const SizedBox(height: 20),
              const Text(
                'This application was developed in partial fulfillment of the requirements for the Degree, Bachelor of Science in Computer Science.',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'Researchers:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text('Jan Angelo N. Heide'),
              const Text('Edrian E. Torraneo'),
              const Text('John Vincent S. Uson'),
            ],
          ),
        ),
      );
    }

    // Safety checks
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (mapData == null || mapData!.buildings.isEmpty) {
      return const Center(child: Text('No buildings found in SVG file'));
    }

    // THE MAP
    return InteractiveViewer(
      transformationController: _transformationController,
      boundaryMargin: const EdgeInsets.fromLTRB(15, 0, 0, 0),
      minScale: 1.11,
      maxScale: 10,
      // clipBehavior: Clip.none,
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
