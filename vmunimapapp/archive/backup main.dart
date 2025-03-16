import 'package:flutter/material.dart';
import 'package:touchable/touchable.dart';

import 'backup functions.dart';

void main() => runApp(const VMUniMapApp());

class VMUniMapApp extends StatelessWidget {
  const VMUniMapApp({super.key});
  static final ColorScheme colorScheme = ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 2, 1, 166),
    brightness: Brightness.light,
    dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VMUniMapApp',
      home: Home(),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        appBarTheme: AppBarTheme(
          foregroundColor: colorScheme.surface,
          backgroundColor: colorScheme.primary,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: colorScheme.primary,
          iconTheme: WidgetStatePropertyAll(
            IconThemeData(color: colorScheme.onPrimary),
          ),
          labelTextStyle: WidgetStatePropertyAll(
            TextStyle(color: colorScheme.onPrimary),
          ),
          indicatorColor: colorScheme.secondary,
          indicatorShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPageIndex = 0;
  String svgFilePath = r'assets/svg/vmunimap.svg';
  Future<Size>? _svgSizeFuture; // Future to hold the SVG size

  @override
  void initState() {
    super.initState();
    _svgSizeFuture = svgSize(svgFilePath); // Initialize the Future in initState
  }

  Future<List<Map<String, dynamic>>> initialize() async {
    return extractPathElements(svgFilePath);
  }

  @override
  Widget build(BuildContext context) {
    print('width: ${MediaQuery.of(context).size.width}');
    print('height: ${MediaQuery.of(context).size.height}');
    return Scaffold(
      appBar: AppBar(title: Text('VMUniMap')),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(icon: Icon(Icons.map), label: 'Map'),
          NavigationDestination(icon: Icon(Icons.info), label: 'Info'),
        ],
      ),
      body: Center(
        child: FutureBuilder<Size>(
          // FutureBuilder to handle svgSize Future
          future: _svgSizeFuture,
          builder: (context, svgSizeSnapshot) {
            if (svgSizeSnapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (svgSizeSnapshot.hasError) {
              return Text('Error loading SVG size: ${svgSizeSnapshot.error}');
            } else if (svgSizeSnapshot.hasData) {
              final svgSizeData = svgSizeSnapshot.data!;
              return LayoutBuilder(
                // LayoutBuilder to get parent size
                builder: (context, constraints) {
                  return SizedBox(
                    width:
                        constraints.maxWidth, // Use LayoutBuilder constraints
                    height:
                        constraints.maxHeight, // Use LayoutBuilder constraints
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: initialize(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          return InteractiveViewer(
                            maxScale: 2.0,
                            minScale: 0.5,
                            alignment: Alignment.topLeft,
                            child: CanvasTouchDetector(
                              gesturesToOverride: [GestureType.onTapDown],
                              builder:
                                  (context) => CustomPaint(
                                    size:
                                        svgSizeData, // Use resolved svgSizeData here
                                    painter: InteractiveMapPainter(
                                      context: context,
                                      pathList: snapshot.data!,
                                    ),
                                  ),
                            ),
                          );
                        } else {
                          return Text('No data');
                        }
                      },
                    ),
                  );
                },
              );
            } else {
              return Text('No SVG size data');
            }
          },
        ),
      ),
    );
  }
}