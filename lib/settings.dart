import 'package:flutter/material.dart';
import 'constants.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(
                Icons.account_circle,
                size: 70,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    "App",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                "Rate Us 🙃",
                style: kSettingText,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                "More Apps",
                style: kSettingText,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                "How to Use",
                style: kSettingText,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                "Recommend",
                style: kSettingText,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                "Private Policy",
                style: kSettingText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
