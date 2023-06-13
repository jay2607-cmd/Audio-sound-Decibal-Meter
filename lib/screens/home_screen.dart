import 'package:flutter/material.dart';
import 'package:jay_sound_meter/screens/camera_home.dart';
import 'package:jay_sound_meter/screens/uploade_video_noise_measure.dart';
import 'package:jay_sound_meter/screens/noise_detector.dart';
import 'package:jay_sound_meter/screens/recorder_homeview.dart';
import 'package:jay_sound_meter/screens/views/reusable_grid_view.dart';
import 'package:jay_sound_meter/screens/save_main.dart';
import 'package:jay_sound_meter/screens/settings.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
              className: NoiseDetector(),
              label: "NOISE DETECTOR",
              getColor: Colors.blue.shade100,
              icon: Icons.accessibility),
          ReusableGridView(
              className: SaveMain.history(),
              label: "HISTORY",
              getColor: Colors.blue.shade200,
              icon: Icons.history_sharp),
          ReusableGridView(
              className: Settings(),
              label: "SETTINGS",
              getColor: Colors.blue.shade300,
              icon: Icons.settings_sharp),
          ReusableGridView(
              className: RecorderHomeView(
                title: 'Recorder',
              ),
              label: "RECORDER",
              getColor: Colors.blue.shade400,
              icon: Icons.record_voice_over_sharp),
          ReusableGridView(
              className: CameraHome(),
              label: "CAMERA",
              getColor: Colors.blue.shade500,
              icon: Icons.camera_enhance_sharp),
          // ReusableGridView(
          //     className: NoiseDetector(),
          //     label: "NOISE DETECTOR",
          //     getColor: Colors.blue.shade500,
          //     icon: Icons.accessibility),
        ],
      ),
    );
  }
}
