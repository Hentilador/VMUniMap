import 'package:flutter/material.dart';

import 'teeth_selector.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text('Teeth Selector')),
        body: Center(
          child: TeethSelector(
            multiSelect: true,
            selectedColor: Colors.blue,
            unselectedColor: Colors.grey,
            onChange: (selectedTeeth) {
              print("Selected Teeth: $selectedTeeth");
            },
          ),
        ),
      ),
    );
  }
}
