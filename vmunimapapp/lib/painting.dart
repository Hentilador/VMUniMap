import 'package:flutter/services.dart';
import 'package:xml/xml.dart';
import 'package:collection/collection.dart';

Future<XmlDocument> loadSvgAsset(String svgFilePath) async {
  XmlDocument document;
  document = XmlDocument.parse(await rootBundle.loadString(svgFilePath));
  return document;
}

class Building {
  final String id;
  final String svgPath;
  final Color fillColor;

  Building({required this.id, required this.svgPath, required this.fillColor});

  // Factory constructor to create a list of buildings from an XML document
  factory Building.fromXmlElement(XmlElement element) {
    final String? id = element.getAttribute('id');
    final String? d = element.getAttribute('d');
    final String? style = element.getAttribute('style');

    if (id == null || d == null || style == null) {
      throw Exception('Invalid building element: missing required attributes');
    }

    final List<String> properties = style.split(';');
    final String fillStr = properties[0].split(':')[1].trim();
    final String opacityStr = properties[1].split(':')[1].trim();

    final int alpha = (double.parse(opacityStr) * 255).round();
    final int rgb = int.parse(fillStr.substring(1), radix: 16);
    final int argb = (alpha << 24) | rgb;
    final Color fillColor = Color(argb);

    return Building(id: id, svgPath: d, fillColor: fillColor);
  }

  // Static method to populate building list from an XML document
  static List<Building> fromDocument(XmlDocument document) {
    final XmlElement? buildingGroup = document
        .findAllElements('g')
        .firstWhereOrNull(
          (element) => element.getAttribute('id') == 'buildings',
        );

    if (buildingGroup == null) {
      throw Exception('No <g> element with id "buildings" found.');
    }

    return buildingGroup
        .findElements('path')
        .map((element) {
          try {
            return Building.fromXmlElement(element);
          } catch (e) {
            print('Skipping invalid element: $e');
            return null;
          }
        })
        .whereType<Building>()
        .toList();
  }

  @override
  String toString() {
    return 'Building{id: $id, svgPath: $svgPath, fillColor: $fillColor}';
  }
}
