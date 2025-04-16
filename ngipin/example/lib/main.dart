import 'package:flutter/material.dart';
import 'package:teeth_selector/teeth_selector.dart';

void main() => runApp(
      MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.blue,
        ),
        home: MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: TeethSelector(
          onChange: (selected) => print(selected),
          multiSelect: false,
          colorized: {
            "15": Colors.teal,
            "26": Colors.orange,
            "24": Colors.transparent,
          },
          StrokedColorized: {"24": Colors.grey.withOpacity(0.5)},
          notation: (isoString) => "Tooth ISO: $isoString",
          selectedColor: Colors.red,
          showPrimary: false,
        ),
      ),
    );
  }
}
