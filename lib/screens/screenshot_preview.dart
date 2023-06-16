import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScreenshotPreview extends StatelessWidget{

  final String filePath;

  ScreenshotPreview({required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(filePath)),
    );
  }

}