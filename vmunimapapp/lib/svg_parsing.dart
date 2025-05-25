import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_drawing/path_drawing.dart' as path_drawing;
import 'package:xml/xml.dart';

final String svgFilePath = r'assets/svg/Campus Map.svg';

// Data class to hold the map information
class CampusMapData {
  final Size size;
  final Map<String, Building> buildings;

  CampusMapData({required this.size, required this.buildings});
}

// Building class to represent each building on the map
class Building {
  final String id;
  final String label;
  final Path path;
  final Color fillColor;
  final Color strokeColor;
  final double strokeWidth;
  bool selected = false;

  Building({
    required this.id,
    this.label = 'N/A',
    required this.path,
    required this.fillColor,
    this.strokeColor = Colors.black,
    required this.strokeWidth,
  });

  // Get the bounds of the path for positioning
  Rect getBounds() {
    return path.getBounds();
  }
}

// Load SVG asset and parse it into a CampusMapData object
Future<CampusMapData> loadCampusMap() async {
  final String svgString = await rootBundle.loadString(svgFilePath);
  final XmlDocument document = XmlDocument.parse(svgString);

  // Get the viewBox dimensions
  final String? viewBox = document.rootElement.getAttribute('viewBox');
  if (viewBox == null) {
    throw Exception('SVG does not have a viewBox attribute');
  }

  final List<String> viewBoxParts = viewBox.split(' ');
  final double width = double.parse(viewBoxParts[2]);
  final double height = double.parse(viewBoxParts[3]);
  final Size size = Size(width, height);

  // Find the buildings group
  final XmlElement? buildingGroup =
      document
          .findAllElements('g')
          .where((element) => element.getAttribute('id') == 'buildings')
          .firstOrNull;

  if (buildingGroup == null) {
    throw Exception('No <g> element with id "buildings" found.');
  }

  // Parse all building paths
  final Map<String, Building> buildings = {};

  for (final element in buildingGroup.findElements('path')) {
    try {
      final String? id = element.getAttribute('id');
      final String? style = element.getAttribute('style');
      final String? d = element.getAttribute('d');
      final String? label = element.getAttribute('inkscape:label');

      if (id == null || d == null) {
        continue;
      }

      // Parse the path data
      final Path path = path_drawing.parseSvgPathData(d);

      // Parse the fill color from style attribute
      Color fillColor = Colors.grey.withOpacity(0.5);
      double strokeWidth = 1.0;
      if (style != null) {
        final List<String> properties = style.split(';');
        for (final property in properties) {
          if (property.startsWith('fill:')) {
            final String fillStr = property.split(':')[1].trim();
            if (fillStr.startsWith('#')) {
              final int rgb = int.parse(fillStr.substring(1), radix: 16);
              fillColor = Color(0xFF000000 | rgb);
            }
          }
          if (property.startsWith('fill-opacity:')) {
            final String opacityStr = property.split(':')[1].trim();
            final double opacity = double.tryParse(opacityStr) ?? 1.0;
            fillColor = fillColor.withOpacity(opacity);
          }
          if (property.startsWith('stroke-width:')) {
            final String strokeWidthStr = property.split(':')[1].trim();
            strokeWidth = double.tryParse(strokeWidthStr) ?? 1.0;
          }
        }
      }

      buildings[id] = Building(
        id: id,
        label: label!,
        path: path,
        fillColor: fillColor,
        strokeWidth: strokeWidth,
      );
    } catch (e) {
      print('Error processing building element: $e');
    }
  }

  return CampusMapData(size: size, buildings: buildings);
}

