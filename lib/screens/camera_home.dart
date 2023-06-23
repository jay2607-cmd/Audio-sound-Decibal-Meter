import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jay_sound_meter/screens/capture_video_and_measure_noise.dart';
import 'package:jay_sound_meter/screens/pickFile.dart';
import 'package:jay_sound_meter/screens/views/reusable_grid_view.dart';

class CameraHome extends StatelessWidget {
  final List<CameraDescription> cameras;
  final Function logError;

  CameraHome({super.key, required this.cameras, required this.logError});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color(0xffF0F1F2),
                    image: DecorationImage(image: AssetImage("assets/images/bg.png"),fit: BoxFit.cover
                    )
                ),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image.asset(
                    //   "assets/images/d1.png",
                    //   height: 60,
                    //   width: 50,
                    //   fit: BoxFit.contain,
                    // ),
                    // Image.asset(
                    //   "assets/images/appname.png",
                    //   height: 150,
                    //   width: 150,
                    //   fit: BoxFit.contain,
                    // ),
                    // Container(
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(30),
                    //     color: Colors.white,
                    //   ),
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(8.0),
                    //     child: Column(
                    //       children: [
                    //         Image.asset("assets/images/info.png",
                    //             height: 35, width: 30, fit: BoxFit.contain),
                    //         SizedBox(height: 7,),
                    //         Image.asset("assets/images/ads.png",
                    //             height: 35, width: 30, fit: BoxFit.contain),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // Divider(color: Color(0xFFDCDFE3),
                    //   thickness: 2,
                    //   indent: Checkbox.width,
                    //   endIndent: Checkbox.width,
                    // ),
                    GridView.count(
                      shrinkWrap: true,
                      primary: false,
                      padding: const EdgeInsets.all(20),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount: 2,
                      children: <Widget>[
                        ReusableGridView(
                          className: CameraApp(cameras: cameras, logError: logError),
                          label1: "",
                          label2: "Camera",
                          imgPath: "assets/images/camera.png",
                        ),
                        ReusableGridView(
                          className: Picker(),
                          label1: "",
                          label2: "Gallery",
                          imgPath: "assets/images/folder.png",
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
    );

  }
}
