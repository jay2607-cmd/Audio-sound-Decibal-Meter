import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'live_screenshot.dart';

class ScreenshotPreview extends StatefulWidget {
  final List<File> imageFiles;
  final int index;
  final String filePath;
  final File file;

  const ScreenshotPreview(
      {super.key,
      required this.filePath,
      required this.file,
      required this.imageFiles,
      required this.index});

  @override
  State<ScreenshotPreview> createState() => _ScreenshotPreviewState();
}

class _ScreenshotPreviewState extends State<ScreenshotPreview> {
  @override
  Widget build(BuildContext context) {
    print(widget.filePath);
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: PhotoView(
                backgroundDecoration: const BoxDecoration(color: Colors.white),
                imageProvider: FileImage(File(widget.filePath)),
              ),
            ),
            Text(widget.filePath.substring(67, 86)),
            // Text(filePath.substring(77, 86 )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    Share.shareFiles([widget.filePath],
                        text: widget.filePath.substring(67, 86));
                  },
                  icon: Icon(Icons.share),
                  label: const Text(
                    "Share",
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Warning!',
                              style: TextStyle(color: Colors.red)),
                          content: const Text(
                              'Are you really want to delete this file!'),
                          actions: [
                            TextButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child: Text('OK'),
                              onPressed: () {
                                setState(() {
                                  deleteFile(widget.filePath, widget.index);
                                  Navigator.pop(context);
                                  setState(() {});
                                });
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.delete),
                  label: Text("Delete"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> deleteFile(String filePath, int index) async {
    try {
      File file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        setState(() {
          widget.imageFiles.remove(file);
          widget.imageFiles
              .removeAt(index); // Remove the deleted file from the list
        });
        // widget.imageFiles.removeAt(index);

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => ImageListScreen()));
        print('$filePath deleted successfully');
      }
    } catch (e) {
      print('Error while deleting file: $e');
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ImageListScreen()));
    }
  }

  Future<bool> _willPopCallback() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ImageListScreen()));
    return Future.value(true);
  }
}
