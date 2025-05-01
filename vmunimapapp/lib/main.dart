import 'package:flutter/material.dart';
// Local Imports
import 'homescreen.dart';
import 'theming.dart' show theme;

void main() => runApp(const VMUniMapApp());

class VMUniMapApp extends StatelessWidget {
  const VMUniMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VMUniMap',
      home: const Home(),
      theme: theme,
      debugShowCheckedModeBanner: false,
    );
  }
}