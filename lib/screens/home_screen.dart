import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:jay_sound_meter/screens/camera_home.dart';
import 'package:jay_sound_meter/screens/noise_detector.dart';
import 'package:jay_sound_meter/screens/recorder_homeview.dart';
import 'package:jay_sound_meter/screens/views/reusable_grid_view.dart';
import 'package:jay_sound_meter/screens/save_main.dart';

import '../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(milliseconds: 1500),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    HomeScreen(cameras: cameras, logError: logError))));
  }

/*  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Container(
          color: Colors.white,
          child: Scaffold(
            body: Column(
              children: [
                AssetImage(""),
                SizedBox(height: 30,),
                Text("Noise Detector"),
              ],
            ),
          ),
        ),
      ),
    );

  }*/
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage("assets/images/splash_icon.png",),height: 155, width: 155,),
            SizedBox(height: 30,),
            Text("Noise",style: TextStyle( fontSize: 35),),
            Text("Detector",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Function logError;
  HomeScreen({super.key, required this.cameras, required this.logError});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
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
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 8, right: 8, top: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/firstpage_icon.png",
                            height: 80,
                            width: 80,
                            fit: BoxFit.contain,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                "assets/images/appname.png",
                                height: 80,
                                width: 150,
                                fit: BoxFit.contain,
                              ),
                            ],
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
                              cameras: widget.cameras,
                              logError: widget.logError),
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
    );
  }
}
