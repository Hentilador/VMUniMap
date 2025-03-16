import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_drawing/path_drawing.dart';
import 'package:touchable/touchable.dart';
import 'package:xml/xml.dart';

Future<XmlDocument> loadSvgAsset(String svgFilePath) async {
  svgFilePath = await rootBundle.loadString(svgFilePath);
  final document = XmlDocument.parse(svgFilePath);
  return document;
}

Future<Size> svgSize(String svgFilePath) async {
  final document = await loadSvgAsset(svgFilePath);
  final String? width = document.rootElement.getAttribute('width');
  final String? height = document.rootElement.getAttribute('height');

  if (width != null && height != null) {
    return Size(double.parse(width), double.parse(height));
  }
  throw Exception();
}


Future<List<Map<String, dynamic>>> extractPathElements(
  String svgFilePath,
) async {
  final document = await loadSvgAsset(svgFilePath);
  final paths = document.findAllElements('path').toList();

  List<Map<String, dynamic>> pathList = [];
  for (var element in paths) {
    if (element.getAttribute('d') == null) {
      continue;
    }
    final idAttribute = element.getAttribute('id').toString();
    final dAttribute = element.getAttribute('d').toString();

    Map<String, dynamic> pathMap = {
      'id': idAttribute,
      'd': parseSvgPathData(dAttribute),
    };

    pathList.add(pathMap);
  }
  return pathList;
}
// TODO: YOU HAVE TO CENTER THE DRAWING 
class InteractiveMapPainter extends CustomPainter {
  final BuildContext context; // Add BuildContext to constructor
  final List<Map<String, dynamic>> pathList;

  InteractiveMapPainter({
    required this.context,
    required this.pathList,
  }); // Constructor to receive context

  @override
  void paint(Canvas canvas, Size size) {
    var myCanvas = TouchyCanvas(context, canvas); // Create TouchyCanvas

    for (int i = 0; i < pathList.length; i++) {
      final pathMap = pathList[i];
      final path = pathMap['d'];

      myCanvas.drawPath(
        path,
        Paint()
          ..color = Colors.blueAccent
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  /// Always return true to force a repaint when the delegate changes.
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

//     Path path_0 = Path();
//     path_0.moveTo(size.width * 0.9604973, size.height * 0.9982436);
//     path_0.lineTo(size.width * 0.9734951, size.height * 0.7119438);
//     path_0.lineTo(size.width * 0.8995418, size.height * 0.7113583);
//     path_0.cubicTo(
//       size.width * 0.8995418,
//       size.height * 0.7113583,
//       size.width * 0.8887849,
//       size.height * 0.7084309,
//       size.width * 0.8825101,
//       size.height * 0.7318501,
//     );
//     path_0.cubicTo(
//       size.width * 0.8762353,
//       size.height * 0.7552693,
//       size.width * 0.8780281,
//       size.height * 0.8981265,
//       size.width * 0.8780281,
//       size.height * 0.8981265,
//     );
//     path_0.lineTo(size.width * 0.9640829, size.height * 0.9004684);
//     path_0.close();

//     Paint paint0Stroke =
//         Paint()
//           ..style = PaintingStyle.stroke
//           ..strokeWidth = size.width * 0.004602289;
//     paint0Stroke.color = Color(0xffffffff).withOpacity(1);
//     myCanvas.drawPath(path_0, paint0Stroke);

//     Path path_1 = Path();
//     path_1.moveTo(size.width * 0.007764707, size.height * 0.4402858);
//     path_1.lineTo(size.width * 0.007130853, size.height * 0.3885361);
//     path_1.lineTo(size.width * 0.05451141, size.height * 0.3881221);
//     path_1.lineTo(size.width * 0.05482834, size.height * 0.4390438);
//     path_1.close();

//     Paint paint1Fill = Paint()..style = PaintingStyle.fill;
//     paint1Fill.color = Color(0xff000000).withOpacity(0.52225518);
//     myCanvas.drawPath(path_1, paint1Fill);

//     Path path_2 = Path();
//     path_2.moveTo(size.width * 0.06576231, size.height * 0.4189649);
//     path_2.lineTo(size.width * 0.09190877, size.height * 0.4187579);
//     path_2.lineTo(size.width * 0.09254263, size.height * 0.4682305);
//     path_2.lineTo(size.width * 0.09381033, size.height * 0.4680236);
//     path_2.lineTo(size.width * 0.09412726, size.height * 0.4833414);
//     path_2.lineTo(size.width * 0.09254263, size.height * 0.4829274);
//     path_2.lineTo(size.width * 0.09222570, size.height * 0.4949333);
//     path_2.lineTo(size.width * 0.07939017, size.height * 0.4953473);
//     path_2.lineTo(size.width * 0.07939017, size.height * 0.5272251);
//     path_2.lineTo(size.width * 0.05419448, size.height * 0.5272251);
//     path_2.lineTo(size.width * 0.05371909, size.height * 0.4665746);
//     path_2.lineTo(size.width * 0.06623770, size.height * 0.4659536);
//     path_2.close();

//     Paint paint2Fill = Paint()..style = PaintingStyle.fill;
//     paint2Fill.color = Color(0xff000000).withOpacity(0.52225518);
//     myCanvas.drawPath(path_2, paint2Fill);

//     Path path_3 = Path();
//     path_3.moveTo(size.width * 0.01333811, size.height * 0.4454607);
//     path_3.lineTo(size.width * 0.03393836, size.height * 0.4450467);
//     path_3.lineTo(size.width * 0.03457221, size.height * 0.5348840);
//     path_3.lineTo(size.width * 0.01333811, size.height * 0.5344701);
//     path_3.close();

//     Paint paint3Fill = Paint()..style = PaintingStyle.fill;
//     paint3Fill.color = Color(0xff000000).withOpacity(0.522255);
//     myCanvas.drawPath(path_3, paint3Fill);

//     Path path_4 = Path();
//     path_4.moveTo(size.width * 0.06481153, size.height * 0.5317791);
//     path_4.lineTo(size.width * 0.1045859, size.height * 0.5313651);
//     path_4.lineTo(size.width * 0.1066459, size.height * 0.6315523);
//     path_4.lineTo(size.width * 0.06528692, size.height * 0.6327943);
//     path_4.close();

//     Paint paint4Fill = Paint()..style = PaintingStyle.fill;
//     paint4Fill.color = Color(0xff000000).withOpacity(0.52225518);
//     myCanvas.drawPath(path_4, paint4Fill);

//     Path path_5 = Path();
//     path_5.moveTo(size.width * 0.01434247, size.height * 0.5427400);
//     path_5.lineTo(size.width * 0.03406337, size.height * 0.5421546);
//     path_5.lineTo(size.width * 0.03518387, size.height * 0.7189696);
//     path_5.lineTo(size.width * 0.01322196, size.height * 0.7195550);
//     path_5.close();

//     Paint paint5Fill = Paint()..style = PaintingStyle.fill;
//     paint5Fill.color = Color(0xff000000).withOpacity(0.52225518);
//     myCanvas.drawPath(path_5, paint5Fill);

//     Path path_6 = Path();
//     path_6.moveTo(size.width * 0.06521342, size.height * 0.6612998);
//     path_6.lineTo(size.width * 0.1042070, size.height * 0.6604215);
//     path_6.lineTo(size.width * 0.1053275, size.height * 0.7555621);
//     path_6.lineTo(size.width * 0.06543752, size.height * 0.7552693);
//     path_6.close();

//     Paint paint6Fill = Paint()..style = PaintingStyle.fill;
//     paint6Fill.color = Color(0xff000000).withOpacity(0.52225518);
//     myCanvas.drawPath(path_6, paint6Fill);

//     Path path_7 = Path();
//     path_7.moveTo(size.width * 0.04952634, size.height * 0.7142857);
//     path_7.lineTo(size.width * 0.05983499, size.height * 0.7139930);
//     path_7.lineTo(size.width * 0.05961089, size.height * 0.7283372);
//     path_7.lineTo(size.width * 0.04952634, size.height * 0.7280445);
//     path_7.close();

//     Paint paint7Fill = Paint()..style = PaintingStyle.fill;
//     paint7Fill.color = Color(0xff000000).withOpacity(0.52225518);
//     myCanvas.drawPath(path_7, paint7Fill);

//     Path path_8 = Path();
//     path_8.moveTo(size.width * 0.05462464, size.height * 0.6698624);
//     path_8.lineTo(size.width * 0.04991852, size.height * 0.6736680);
//     path_8.lineTo(size.width * 0.04991852, size.height * 0.6801083);
//     path_8.lineTo(size.width * 0.05440054, size.height * 0.6833284);
//     path_8.lineTo(size.width * 0.05882654, size.height * 0.6801083);
//     path_8.lineTo(size.width * 0.05877051, size.height * 0.6731557);
//     path_8.close();

//     Paint paint8Fill = Paint()..style = PaintingStyle.fill;
//     paint8Fill.color = Color(0xff000000).withOpacity(0.52225518);
//     myCanvas.drawPath(path_8, paint8Fill);

//     Path path_9 = Path();
//     path_9.moveTo(size.width * 0.08851993, size.height * 0.9590164);
//     path_9.lineTo(size.width * 0.05714578, size.height * 0.9601874);
//     path_9.lineTo(size.width * 0.05669758, size.height * 0.8987119);
//     path_9.lineTo(size.width * 0.04773353, size.height * 0.8990047);
//     path_9.lineTo(size.width * 0.04795763, size.height * 0.9288642);
//     path_9.lineTo(size.width * 0.02061730, size.height * 0.9297424);
//     path_9.lineTo(size.width * 0.01949679, size.height * 0.7590749);
//     path_9.lineTo(size.width * 0.04706123, size.height * 0.7593677);
//     path_9.lineTo(size.width * 0.04728533, size.height * 0.8044496);
//     path_9.lineTo(size.width * 0.06364471, size.height * 0.8038642);
//     path_9.lineTo(size.width * 0.06342061, size.height * 0.8325527);
//     path_9.lineTo(size.width * 0.08717533, size.height * 0.8316745);
//     path_9.close();

//     Paint paint9Fill = Paint()..style = PaintingStyle.fill;
//     paint9Fill.color = Color(0xff000000).withOpacity(0.52225518);
//     myCanvas.drawPath(path_9, paint9Fill);

//     Path path_10 = Path();
//     path_10.moveTo(size.width * 0.1658348, size.height * 0.6838407);
//     path_10.lineTo(size.width * 0.1920546, size.height * 0.6481265);
//     path_10.lineTo(size.width * 0.2055007, size.height * 0.6495902);
//     path_10.lineTo(size.width * 0.2104309, size.height * 0.6457845);
//     path_10.lineTo(size.width * 0.2128960, size.height * 0.6466628);
//     path_10.lineTo(size.width * 0.2160335, size.height * 0.6437354);
//     path_10.lineTo(size.width * 0.2227565, size.height * 0.6487119);
//     path_10.lineTo(size.width * 0.2281349, size.height * 0.6583724);
//     path_10.lineTo(size.width * 0.2256698, size.height * 0.6610070);
//     path_10.lineTo(size.width * 0.2276867, size.height * 0.6662763);
//     path_10.lineTo(size.width * 0.2232047, size.height * 0.6733021);
//     path_10.lineTo(size.width * 0.2247734, size.height * 0.6929157);
//     path_10.lineTo(size.width * 0.1978813, size.height * 0.7265808);
//     path_10.lineTo(size.width * 0.1754712, size.height * 0.7543911);
//     path_10.lineTo(size.width * 0.1553021, size.height * 0.7283372);
//     path_10.lineTo(size.width * 0.1618010, size.height * 0.7201405);
//     path_10.lineTo(size.width * 0.1508200, size.height * 0.7087236);
//     path_10.lineTo(size.width * 0.1676276, size.height * 0.6864754);
//     path_10.close();

//     Paint paint10Fill = Paint()..style = PaintingStyle.fill;
//     paint10Fill.color = Color(0xff000000).withOpacity(0.52225518);
//     myCanvas.drawPath(path_10, paint10Fill);

//     Path path_11 = Path();
//     path_11.moveTo(size.width * 0.2350820, size.height * 0.7476581);
//     path_11.lineTo(size.width * 0.2776613, size.height * 0.7488290);
//     path_11.lineTo(size.width * 0.2772131, size.height * 0.7772248);
//     path_11.lineTo(size.width * 0.2337374, size.height * 0.7757611);
//     path_11.close();

//     Paint paint11Fill = Paint()..style = PaintingStyle.fill;
//     paint11Fill.color = Color(0xff000000).withOpacity(0.52225518);
//     myCanvas.drawPath(path_11, paint11Fill);

//     Path path_12 = Path();
//     path_12.moveTo(size.width * 0.08896813, size.height * 0.3681206);
//     path_12.lineTo(size.width * 0.1110421, size.height * 0.3678279);
//     path_12.lineTo(size.width * 0.1091372, size.height * 0.2015515);
//     path_12.lineTo(size.width * 0.08930429, size.height * 0.2018443);
//     path_12.close();

//     Paint paint12Fill = Paint()..style = PaintingStyle.fill;
//     paint12Fill.color = Color(0xff000000).withOpacity(0.52225518);
//     myCanvas.drawPath(path_12, paint12Fill);

//     Path path_13 = Path();
//     path_13.moveTo(size.width * 0.08975249, size.height * 0.1894028);
//     path_13.lineTo(size.width * 0.1099216, size.height * 0.1888173);
//     path_13.lineTo(size.width * 0.1099216, size.height * 0.02166276);
//     path_13.lineTo(size.width * 0.08975249, size.height * 0.02122365);
//     path_13.close();

//     Paint paint13Fill = Paint()..style = PaintingStyle.fill;
//     paint13Fill.color = Color(0xff000000).withOpacity(0.52225518);
//     myCanvas.drawPath(path_13, paint13Fill);

//     Path path_14 = Path();
//     path_14.moveTo(size.width * 0.1648019, size.height * 0.02359783);
//     path_14.lineTo(size.width * 0.2066363, size.height * 0.02111384);
//     path_14.lineTo(size.width * 0.2072701, size.height * 0.06748150);
//     path_14.lineTo(size.width * 0.1654358, size.height * 0.06872349);
//     path_14.close();

//     Paint paint14Fill = Paint()..style = PaintingStyle.fill;
//     paint14Fill.color = Color(0xff000000).withOpacity(0.52225518);
//     myCanvas.drawPath(path_14, paint14Fill);

//     Path path_15 = Path();
//     path_15.moveTo(size.width * 0.1100336, size.height * 0.7862998);
//     path_15.lineTo(size.width * 0.4051748, size.height * 0.7915691);
//     path_15.lineTo(size.width * 0.4047266, size.height * 0.8237705);
//     path_15.lineTo(size.width * 0.3926251, size.height * 0.8237705);
//     path_15.lineTo(size.width * 0.3928492, size.height * 0.8202576);
//     path_15.lineTo(size.width * 0.1225833, size.height * 0.8149883);
//     path_15.lineTo(size.width * 0.1225833, size.height * 0.8182084);
//     path_15.lineTo(size.width * 0.1098095, size.height * 0.8179157);
//     path_15.close();

//     Paint paint15Fill = Paint()..style = PaintingStyle.fill;
//     paint15Fill.color = Color(0xff000000).withOpacity(0.52225518);
//     myCanvas.drawPath(path_15, paint15Fill);

//     Path path_16 = Path();
//     path_16.moveTo(size.width * 0.4060712, size.height * 0.7914227);
//     path_16.lineTo(size.width * 0.4055109, size.height * 0.8067916);
//     path_16.lineTo(size.width * 0.4101050, size.height * 0.8066452);
//     path_16.lineTo(size.width * 0.4098809, size.height * 0.8249414);
//     path_16.lineTo(size.width * 0.5436693, size.height * 0.8269906);
//     path_16.lineTo(size.width * 0.5437813, size.height * 0.7940574);
//     path_16.close();

//     Paint paint16Fill = Paint()..style = PaintingStyle.fill;
//     paint16Fill.color = Color(0xff000000).withOpacity(0.52225518);
//     myCanvas.drawPath(path_16, paint16Fill);

//     Path path_17 = Path();
//     path_17.moveTo(size.width * 0.5484874, size.height * 0.7943501);
//     path_17.lineTo(size.width * 0.5480392, size.height * 0.8277225);
//     path_17.lineTo(size.width * 0.6792504, size.height * 0.8283080);
//     path_17.lineTo(size.width * 0.6784661, size.height * 0.7939110);
//     path_17.close();

//     Paint paint17Fill = Paint()..style = PaintingStyle.fill;
//     paint17Fill.color = Color(0xff000000).withOpacity(0.52225518);
//     myCanvas.drawPath(path_17, paint17Fill);

//     Path path_18 = Path();
//     path_18.moveTo(size.width * 0.4952634, size.height * 0.3928571);
//     path_18.lineTo(size.width * 0.5651830, size.height * 0.3922717);
//     path_18.lineTo(size.width * 0.5647348, size.height * 0.4092506);
//     path_18.lineTo(size.width * 0.5584599, size.height * 0.7570258);
//     path_18.lineTo(size.width * 0.4858512, size.height * 0.7546838);
//     path_18.close();

//     Paint paint18Fill = Paint()..style = PaintingStyle.fill;
//     paint18Fill.color = Color(0xff000000).withOpacity(0.52225518);
//     myCanvas.drawPath(path_18, paint18Fill);

//     Path path_19 = Path();
//     path_19.moveTo(size.width * 0.3061513, size.height * 0.3792212);
//     path_19.cubicTo(
//       size.width * 0.3061513,
//       size.height * 0.3792212,
//       size.width * 0.3077359,
//       size.height * 0.3349235,
//       size.width * 0.3441825,
//       size.height * 0.3018038,
//     );
//     path_19.cubicTo(
//       size.width * 0.3806291,
//       size.height * 0.2686840,
//       size.width * 0.4300697,
//       size.height * 0.2765500,
//       size.width * 0.4516207,
//       size.height * 0.2972498,
//     );
//     path_19.cubicTo(
//       size.width * 0.4731717,
//       size.height * 0.3179496,
//       size.width * 0.4785595,
//       size.height * 0.3369935,
//       size.width * 0.4785595,
//       size.height * 0.3369935,
//     );
//     path_19.lineTo(size.width * 0.4918704, size.height * 0.3365795);
//     path_19.lineTo(size.width * 0.4861657, size.height * 0.7062788);
//     path_19.lineTo(size.width * 0.4658824, size.height * 0.7062788);
//     path_19.cubicTo(
//       size.width * 0.4658824,
//       size.height * 0.7062788,
//       size.width * 0.4357744,
//       size.height * 0.7584424,
//       size.width * 0.3860169,
//       size.height * 0.7518184,
//     );
//     path_19.cubicTo(
//       size.width * 0.3362593,
//       size.height * 0.7451945,
//       size.width * 0.3067852,
//       size.height * 0.6735730,
//       size.width * 0.3067852,
//       size.height * 0.6735730,
//     );
//     path_19.close();

//     Paint paint19Fill = Paint()..style = PaintingStyle.fill;
//     paint19Fill.color = Color(0xff000000).withOpacity(0.52225518);
//     myCanvas.drawPath(path_19, paint19Fill);

//     Path path_20 = Path();
//     path_20.moveTo(size.width * 0.6725187, size.height * 0.3846032);
//     path_20.lineTo(size.width * 0.6316351, size.height * 0.3808772);
//     path_20.lineTo(size.width * 0.6290997, size.height * 0.4756825);
//     path_20.lineTo(size.width * 0.6205427, size.height * 0.4748545);
//     path_20.lineTo(size.width * 0.6199088, size.height * 0.5609659);
//     path_20.lineTo(size.width * 0.6278320, size.height * 0.5605519);
//     path_20.lineTo(size.width * 0.6246627, size.height * 0.7572004);
//     path_20.lineTo(size.width * 0.6687156, size.height * 0.7584424);
//     path_20.lineTo(size.width * 0.6766387, size.height * 0.3850172);
//     path_20.close();

//     Paint paint20Fill = Paint()..style = PaintingStyle.fill;
//     paint20Fill.color = Color(0xff000000).withOpacity(0.52225518);
//     myCanvas.drawPath(path_20, paint20Fill);

//     Path path_21 = Path();
//     path_21.moveTo(size.width * 0.6975559, size.height * 0.5386100);
//     path_21.lineTo(size.width * 0.8626748, size.height * 0.5439920);
//     path_21.lineTo(size.width * 0.8626748, size.height * 0.5104582);
//     path_21.lineTo(size.width * 0.6981898, size.height * 0.5063183);
//     path_21.close();

//     Paint paint21Fill = Paint()..style = PaintingStyle.fill;
//     paint21Fill.color = Color(0xff000000).withOpacity(0.52225518);
//     myCanvas.drawPath(path_21, paint21Fill);

//     Path path_22 = Path();
//     path_22.moveTo(size.width * 0.6924851, size.height * 0.5816657);
//     path_22.lineTo(size.width * 0.7685475, size.height * 0.5833217);
//     path_22.lineTo(size.width * 0.7672798, size.height * 0.6259634);
//     path_22.lineTo(size.width * 0.6921681, size.height * 0.6259634);
//     path_22.close();

//     Paint paint22Fill = Paint()..style = PaintingStyle.fill;
//     paint22Fill.color = Color(0xff000000).withOpacity(0.52225518);
//     myCanvas.drawPath(path_22, paint22Fill);

//     Path path_23 = Path();
//     path_23.moveTo(size.width * 0.7764707, size.height * 0.5841497);
//     path_23.lineTo(size.width * 0.8595055, size.height * 0.5841497);
//     path_23.lineTo(size.width * 0.8595055, size.height * 0.6238934);
//     path_23.lineTo(size.width * 0.7764707, size.height * 0.6238934);
//     path_23.close();

//     Paint paint23Fill = Paint()..style = PaintingStyle.fill;
//     paint23Fill.color = Color(0xff000000).withOpacity(0.52225518);
//     myCanvas.drawPath(path_23, paint23Fill);

//     Path path_24 = Path();
//     path_24.moveTo(size.width * 0.6791741, size.height * 0.4967963);
//     path_24.lineTo(size.width * 0.7105499, size.height * 0.4967963);
//     path_24.lineTo(size.width * 0.7105499, size.height * 0.4578806);
//     path_24.lineTo(size.width * 0.6782234, size.height * 0.4578806);
//     path_24.close();

//     Paint paint24Fill = Paint()..style = PaintingStyle.fill;
//     paint24Fill.color = Color(0xff000000).withOpacity(0.52225518);
//     myCanvas.drawPath(path_24, paint24Fill);

//     Path path_25 = Path();
//     path_25.moveTo(size.width * 0.7225931, size.height * 0.7240806);
//     path_25.lineTo(size.width * 0.7397072, size.height * 0.7240806);
//     path_25.lineTo(size.width * 0.7397072, size.height * 0.7062788);
//     path_25.lineTo(size.width * 0.7523842, size.height * 0.7062788);
//     path_25.lineTo(size.width * 0.7523842, size.height * 0.6872349);
//     path_25.lineTo(size.width * 0.8626748, size.height * 0.6872349);
//     path_25.lineTo(size.width * 0.8626748, size.height * 0.7112467);
//     path_25.lineTo(size.width * 0.8759857, size.height * 0.7112467);
//     path_25.lineTo(size.width * 0.8759857, size.height * 0.7497485);
//     path_25.lineTo(size.width * 0.8845427, size.height * 0.7497485);
//     path_25.lineTo(size.width * 0.9007060, size.height * 0.7497485);
//     path_25.lineTo(size.width * 0.9007060, size.height * 0.8060520);
//     path_25.lineTo(size.width * 0.8750349, size.height * 0.8060520);
//     path_25.lineTo(size.width * 0.8750349, size.height * 0.8246819);
//     path_25.lineTo(size.width * 0.8582378, size.height * 0.8246819);
//     path_25.lineTo(size.width * 0.8582378, size.height * 0.8491077);
//     path_25.lineTo(size.width * 0.7466796, size.height * 0.8491077);
//     path_25.lineTo(size.width * 0.7466796, size.height * 0.8259239);
//     path_25.lineTo(size.width * 0.7210085, size.height * 0.8259239);
//     path_25.close();

//     Paint paint25Fill = Paint()..style = PaintingStyle.fill;
//     paint25Fill.color = Color(0xff000000).withOpacity(0.52225518);
//     myCanvas.drawPath(path_25, paint25Fill);

//     Path path_26 = Path();
//     path_26.moveTo(size.width * 0.2348428, size.height * 0.1374470);
//     path_26.lineTo(size.width * 0.2041009, size.height * 0.1374470);
//     path_26.lineTo(size.width * 0.2041009, size.height * 0.1796747);
//     path_26.lineTo(size.width * 0.2348428, size.height * 0.1796747);
//     path_26.close();

//     Paint paint26Fill = Paint()..style = PaintingStyle.fill;
//     paint26Fill.color = Color(0xff000000).withOpacity(0.52225518);
//     myCanvas.drawPath(path_26, paint26Fill);
//   }

  // @override
  // bool shouldRepaint(covariant CustomPainter oldDelegate) {
  //   return true;
  // }

// }