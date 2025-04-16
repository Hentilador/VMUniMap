import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vmunimapapp/moreinfoscreen.dart';
import 'package:vmunimapapp/text_formatting.dart';

class InfoSheet extends StatelessWidget {
  final String selectedBuildingID;
  final String buildingName;

  const InfoSheet({
    super.key,
    required this.selectedBuildingID,
    required this.buildingName,
  });

  final String buildingDescription = 'Lorem ipsum dolor sit amet';

  Future<Image> _loadImage() async {
    Image img;
    try {
      Future<ByteData> assetData = rootBundle.load(
        'assets/images/$selectedBuildingID.jpg',
      );
      img = Image.memory(Uint8List.sublistView(await assetData));
    } catch (e) {
      Future<ByteData> assetData = rootBundle.load('assets/images/default.jpg');
      img = Image.memory(Uint8List.sublistView(await assetData));
    }
    return img;
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: FutureBuilder(
                      future: _loadImage(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return snapshot.data!;
                        } else if (snapshot.hasError) {
                          print(snapshot.error);
                          return Placeholder();
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                  ),
                  Text(buildingName, style: titleText),
                  SizedBox(height: 12),
                  Text(buildingDescription),
                  SizedBox(height: 12),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => MoreInfoPage(
                          selectedBuildingID: selectedBuildingID,
                          buildingName: buildingName,
                          buildingDescription: buildingDescription,
                        ),
                  ),
                );
              },
              child: Text('More info'),
            ),
          ],
        ),
      ),
    );
  }
}
