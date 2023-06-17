import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ScreenshotPreview extends StatelessWidget {
  final String filePath;
  final File file;
  const ScreenshotPreview(
      {super.key, required this.filePath, required this.file});

  @override
  Widget build(BuildContext context) {
    print(filePath);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PhotoView(
              backgroundDecoration: BoxDecoration(color: Colors.white),
              imageProvider: FileImage(File(filePath)),
            ),
          ),
          Text(filePath.substring(67, 86)),
          // Text(filePath.substring(77, 86 )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: () async {
                final uri = Uri.parse(filePath);
                final response =await http.get(uri);
                final imageBytes = response.bodyBytes;
                final t = getTemporaryDirectory();
                // final path =  await "${t.path}/sharedImage.jpg";
              },
                  child: Text("Share")),
              SizedBox(
                width: 15,
              ),
              ElevatedButton(
                  onPressed: () {
                    deleteFile(file);
                  },
                  child: Text("Delete")),
            ],
          )
        ],
      ),
    );
  }

  Future<void> deleteFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
        print(file);
        // setState(() {
        //   records.remove(file);
        //   widget.records
        //       .removeAt(index); // Remove the deleted file from the list
        // });
      }
    } catch (e) {
      print(e);
    }
  }
}
