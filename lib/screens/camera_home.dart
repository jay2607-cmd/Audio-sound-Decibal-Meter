import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jay_sound_meter/screens/capture_video_and_measure_noise.dart';
import 'package:jay_sound_meter/screens/upload_video_noise_measure.dart';
import 'package:jay_sound_meter/screens/views/reusable_grid_view.dart';

class CameraHome extends StatelessWidget{

  final List<CameraDescription> cameras;
  final Function logError;

  CameraHome({super.key,required this.cameras, required this.logError});

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text("Noise Detector".toUpperCase()),
       centerTitle: true,
     ),
     body: GridView.count(
       primary: false,
       padding: const EdgeInsets.all(20),
       crossAxisSpacing: 10,
       mainAxisSpacing: 10,
       crossAxisCount: 2,
       children: <Widget>[
         ReusableGridView(
             className: CameraApp(cameras: cameras,logError: logError),
             label: "Capture".toUpperCase(),
             getColor: Colors.blue.shade100,
             icon: Icons.camera_alt),
         ReusableGridView(
             className: UploadedVideoNoiseMeasure(),
             label: "Upload".toUpperCase(),
             getColor: Colors.blue.shade200,
             icon: Icons.upload_sharp),

       ],
     ),
   );
  }

}