// The main entry point for the VMUniMap app.

// External Imports
import 'package:flutter/material.dart';

// Local Imports
import 'homescreen.dart';
import 'theming.dart' show theme;

// The main function is the entry point for the app.
void main() => runApp(const VMUniMapApp());

// The VMUniMapApp is the root widget of the app.
class VMUniMapApp extends StatelessWidget {
  // The constructor for the VMUniMapApp widget.
  const VMUniMapApp({super.key});

  // The build method is called when the widget is inserted into the tree.
  @override
  Widget build(BuildContext context) {
    // The home property is the widget that is displayed when the app is first
    // launched.
    return MaterialApp(
      // The title of the app is displayed in the app bar.
      title: 'VMUniMap',
      // The home property is the widget that is displayed when the app is first
      // launched.
      home: const Home(),
      // The theme of the app is the set of colors and fonts that are used
      // throughout the app.
      theme: theme,
      debugShowCheckedModeBanner: false,
    );
  }
}