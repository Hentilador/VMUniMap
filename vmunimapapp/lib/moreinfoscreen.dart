import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vmunimapapp/text_formatting.dart';


class MoreInfoPage extends StatelessWidget {
  final String selectedBuildingID;
  final String buildingName;
  final String buildingDescription;

  const MoreInfoPage({
    super.key,
    required this.selectedBuildingID,
    required this.buildingName,
    required this.buildingDescription,
  });

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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
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
            // Add more details here...
          ],
          
        ),
      ),
    );
  }
}
