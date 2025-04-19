import 'package:flutter/material.dart';

final titleText = TextStyle(fontWeight: FontWeight.bold, fontSize: 26);
final headerText = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
final propertyText = TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
String capitalize(String text) {
  return text[0].toUpperCase() + text.substring(1);
}
