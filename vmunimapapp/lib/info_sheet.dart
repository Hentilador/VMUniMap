import 'package:flutter/material.dart';
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
                    child: Image.asset(
                      'assets/images/$selectedBuildingID.jpg',
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset('assets/images/default.jpg');
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
