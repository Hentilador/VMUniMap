import 'package:flutter/material.dart';
// External Imports
// Local Imports
import 'package:vmunimapapp/svg_parsing.dart';

class CampusMapWidget extends StatefulWidget {
  final CampusMapData mapData;
  final void Function(String buildingId) onBuildingSelected;
  final String? selectedBuildingID;
  // final Color selectedColor;
  final Color strokeColor;

  const CampusMapWidget({
    super.key,
    required this.mapData,
    required this.onBuildingSelected,
    this.selectedBuildingID,
    // this.selectedColor = Colors.blue,
    this.strokeColor = Colors.black,
  });

  @override
  State<CampusMapWidget> createState() => _CampusMapWidgetState();
}

class _CampusMapWidgetState extends State<CampusMapWidget> {
  String? hoveredBuildingID;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: SizedBox.fromSize(
        size: widget.mapData.size,
        child: Stack(
          children: [
            // Background elements could be added here
            Image.asset('assets/images/campus.webp', filterQuality: FilterQuality.medium,),
            // Buildings
            for (final MapEntry(key: id, value: building)
                in widget.mapData.buildings.entries)
              Positioned.fromRect(
                rect: building.path.getBounds(),
                child: MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      hoveredBuildingID = id;
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      hoveredBuildingID = null;
                    });
                  },
                  child: GestureDetector(
                    key: Key("building-$id"),
                    onTap: () {
                      widget.onBuildingSelected(id);
                    },
                    child: Tooltip(
                      message: building.label,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          color: (hoveredBuildingID == id
                                  ? HSLColor.fromColor(building.fillColor)
                                      .withLightness(
                                          (building.fillColor.computeLuminance() +
                                                  0.05)
                                              .clamp(0.0, 1.0))
                                      .withSaturation(0.85)
                                      .toColor()
                                  : building.fillColor),
                          shape: BuildingBorder(
                            building.path.shift(
                              -building.path.getBounds().topLeft,
                            ),
                            strokeColor: widget.strokeColor,
                            strokeWidth: building.strokeWidth,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class BuildingBorder extends ShapeBorder {
  final Path path;
  final double strokeWidth;
  final Color strokeColor;

  const BuildingBorder(
    this.path, {
    required this.strokeWidth,
    required this.strokeColor,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      getOuterPath(rect);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return rect.topLeft == Offset.zero ? path : path.shift(rect.topLeft);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..color = strokeColor;
    canvas.drawPath(getOuterPath(rect), paint);
  }

  @override
  ShapeBorder scale(double t) => this;
}
