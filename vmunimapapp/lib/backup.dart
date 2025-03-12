import 'package:flutter/material.dart';
import 'package:touchable/touchable.dart';

import 'functions.dart';

void main() {
  runApp(VMUniMapApp());
}

class VMUniMapApp extends StatelessWidget {
  VMUniMapApp({super.key});
  final ColorScheme colorScheme = ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 2, 1, 166),
    brightness: Brightness.light,
    dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
  final TransformationController _controller = TransformationController();

  Future<List<Map<String, dynamic>>> initialize() async {
    String svgFilePath = await loadSvgAsset('assets/svg/vmunimap.svg');
    return extractPathElements(svgFilePath);
  }

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
        destinations: const <Widget>[
          NavigationDestination(icon: Icon(Icons.map), label: 'Map'),
          NavigationDestination(icon: Icon(Icons.info), label: 'Info'),
        ],
      ),

      body: Center(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: initialize(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              return InteractiveViewer(
                // clipBehavior: Clip.none,
                transformationController: _controller,
                constrained: false,
                maxScale: 1.5,
                minScale: 1,
                alignment: Alignment.center,
                boundaryMargin: EdgeInsets.all(100),
                
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: CanvasTouchDetector(
                    gesturesToOverride: [GestureType.onTapDown],
                    builder:
                        (context) => CustomPaint(
                          size: Size(
                            MediaQuery.of(context).size.width *0.5,
                            MediaQuery.of(context).size.height *0.5,
                          ),
                          painter: InteractiveMapPainter(
                            context: context,
                            pathList: snapshot.data!,
                          ),
                        ),
                  ),
                ),
              );
            } else {
              return Text('No data');
            }
          },
        ),
      ),
    );
  }
}
