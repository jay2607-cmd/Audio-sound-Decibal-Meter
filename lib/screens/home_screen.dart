import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:jay_sound_meter/screens/camera_home.dart';
import 'package:jay_sound_meter/screens/noise_detector.dart';
import 'package:jay_sound_meter/screens/recorder_homeview.dart';
import 'package:jay_sound_meter/screens/views/reusable_grid_view.dart';
import 'package:jay_sound_meter/screens/save_main.dart';

class HomeScreen extends StatelessWidget {
  final List<CameraDescription> cameras;
  final Function logError;
  HomeScreen({super.key, required this.cameras, required this.logError});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color(0xffF0F1F2),
                      image: DecorationImage(
                          image: AssetImage("assets/images/bg.png"),
                          fit: BoxFit.cover)),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Image.asset(
                              "assets/images/d1.png",
                              height: 80,
                              width: 80,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Image.asset(
                            "assets/images/appname.png",
                            height: 70,
                            width: 150,
                            fit: BoxFit.contain,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 13, bottom: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                children: [
                                  Image.asset("assets/images/info.png",
                                      height: 35,
                                      width: 30,
                                      fit: BoxFit.contain),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  Image.asset("assets/images/ads.png",
                                      height: 35,
                                      width: 30,
                                      fit: BoxFit.contain),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      Divider(
                        color: Color(0xFFDCDFE3),
                        thickness: 2,
                        indent: Checkbox.width,
                        endIndent: Checkbox.width,
                      ),
                      GridView.count(
                        childAspectRatio: 4 / 3,
                        shrinkWrap: true,
                        primary: false,
                        padding: const EdgeInsets.only(
                            left: 18, top: 7.5, bottom: 15, right: 18),
                        crossAxisSpacing: 18,
                        mainAxisSpacing: 16,
                        crossAxisCount: 2,
                        children: <Widget>[
                          ReusableGridView(
                            className: NoiseDetector(),
                            label1: "Noise",
                            label2: "Detector",
                            imgPath: "assets/images/b1.png",
                          ),
                          ReusableGridView(
                            className: SaveMain.history(),
                            label1: "Noise",
                            label2: "History",
                            imgPath: "assets/images/b2.png",
                          ),
                          ReusableGridView(
                            className: RecorderHomeView(
                              title: 'Recorder',
                            ),
                            label1: "Voice",
                            label2: "Recorder",
                            imgPath: "assets/images/b3.png",
                          ),
                          ReusableGridView(
                            className: CameraHome(
                                cameras: cameras, logError: logError),
                            label1: "Noise",
                            label2: "From My Files",
                            imgPath: "assets/images/b4.png",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
