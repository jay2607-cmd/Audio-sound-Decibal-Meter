
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jay_sound_meter/screens/upload_video_noise_measure.dart';

class Picker extends StatefulWidget {
  const Picker({super.key});

  @override
  State<Picker> createState() => _PickerState();
}

class _PickerState extends State<Picker> {
 late  PickedFile pickedFile;
  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            pickedFile = (await picker.getVideo(source: ImageSource.gallery))!;
            Navigator.push(
                context, MaterialPageRoute(builder: (builder) => VideoDemo(videoPath: pickedFile.path,)));
          },
          child: Text("Upload"),
        ),
      ),
    );
  }
}
