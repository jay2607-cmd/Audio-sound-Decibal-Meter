import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jay_sound_meter/screens/screenshot_preview.dart';
import 'package:path_provider/path_provider.dart';

class ImageListScreen extends StatefulWidget{
  @override
  _ImageListScreenState createState() => _ImageListScreenState();
}

class _ImageListScreenState extends State<ImageListScreen> with WidgetsBindingObserver{
  late List<File> imageFiles;
  late File file;

  @override
  void initState() {
    super.initState();
    loadImages();
    print("initState");
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // print("didChangeAppLifecycleState");
    if(state == AppLifecycleState.resumed){
      // user returned to our app
      print("resumed");
    }else if(state == AppLifecycleState.inactive){
      // app is inactive
      print("inactive");
    }else if(state == AppLifecycleState.paused){
      // user is about quit our app temporally
      print("paused");
    }else if(state == AppLifecycleState.detached){
      print("suspending");
      // app suspended (not used in iOS)
    }
  }



  Future<void> loadImages() async {
    final directory = await getExternalStorageDirectory();
    print(directory);
    final files = directory?.listSync(recursive: true);
    final pngFiles = files?.whereType<File>().where((file) {
      final extension = file.path.toLowerCase().split('.').last;
      return extension == 'png';
    }).toList();
    setState(() {
      imageFiles = pngFiles!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PNG Images'),
        centerTitle: true,
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 50.0,
        ),
        itemCount: imageFiles.length,
        itemBuilder: (BuildContext context, int index) {
          file = imageFiles[index];
          return GestureDetector(
            onTap: () {
              print("${index}");
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ScreenshotPreview(
                            filePath: imageFiles[index].path,
                            file: imageFiles[index],
                            imageFiles: imageFiles,
                            index: index,
                          )));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Image.file(file),
                ),
                Text(file.path.substring(67, 77)),
                Text(file.path.substring(77, 86)),
              ],
            ),
          );
        },
      ),
    );
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    print("dispose");
    super.dispose();
  }

}
