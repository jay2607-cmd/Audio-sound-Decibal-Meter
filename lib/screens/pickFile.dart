/*import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jay_sound_meter/logic/dB_meter.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:video_player/video_player.dart';

import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jay_sound_meter/screens/upload_video_noise_measure.dart';

import '../utils/constants.dart';

class Picker extends StatefulWidget {

  Picker({super.key});

  @override
  State<Picker> createState() => _PickerState();
}

class _PickerState extends State<Picker> {

  String videoPath = "";
  late PickedFile pickedFile;
  final ImagePicker picker = ImagePicker();

  bool isRecording = false;
  bool _isPlaying = false;
  StreamSubscription<NoiseReading>? noiseSubscription;
  late NoiseMeter noiseMeter;
  double maxDB = 0;
  double? meanDB;

  void onData(NoiseReading noiseReading) {
    setState(() {
      if (controller.value.isPlaying) {
        _isPlaying = true;
      } else {
        _isPlaying = false;
        stop();
      }
      // print("dataa: {$_isPlaying}");
    });
    maxDB = noiseReading.maxDecibel;
    meanDB = noiseReading.meanDecibel;
  }

  // error handle
  void onError(Object e) {
    isRecording = false;
  }

  void start() async {
    try {
      noiseSubscription = noiseMeter.noiseStream.listen(onData);
    } catch (e) {
      print(e);
    }
  }

  void stop() async {
    try {
      noiseSubscription!.cancel();
      noiseSubscription = null;

      // setState(() => {},);
    } catch (e) {
      print('stopRecorder error: $e');
    }
  }

  late VideoPlayerController controller;
  late Future<void> video;


  @override
  void initState() {
    super.initState();
    noiseMeter = NoiseMeter(onError);
    // if(widget.videoPath.isNotEmpty){
    //
    // }
    controller = VideoPlayerController.file(File(videoPath));
    video = controller.initialize();
    controller.setLooping(false);
    controller.setVolume(1.0);
  }

  @override
  void dispose() {
    stop();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: IconButton(
            icon: Image.asset(
              'assets/images/back.png',
              height: 28,
              width: 28,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            "My Files",
            style: kAppbarStyle,
          ),
        ),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () async {
              pickedFile =
                  (await picker.getVideo(source: ImageSource.gallery))!;
              print("Pathh:${pickedFile.path}");
              setState(() {
                videoPath = pickedFile.path;
              });
              // VideoDemo(
              //   videoPath: pickedFile.path,
              // );
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (builder) => VideoDemo(
              //               videoPath: pickedFile.path,
              //             )));

            },
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: DottedBorder(
                borderType: BorderType.RRect,
                color: Color(0xffCED3D9),
                strokeWidth: 4,
                radius: Radius.circular(10),
                strokeCap: StrokeCap.butt,
                dashPattern: const [12, 15],
                child: Container(
                  height: 120,
                  width: 300,
                  decoration: BoxDecoration(
                      // border: Border.all(color: Colors.black, width: 4),
                      // borderRadius: BorderRadius.circular(10)
                      ),
                  child: Column(
                    children: [
                      IconButton(
                        iconSize: 72,
                        onPressed: () async {
                          pickedFile = (await picker.getVideo(
                              source: ImageSource.gallery))!;
                          print("Pathh:${pickedFile.path}");
                          setState(() {
                            videoPath = pickedFile.path;
                          });
                          // VideoDemo(
                          //   videoPath: pickedFile.path,
                          // );
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (builder) => VideoDemo(
                          //               videoPath: pickedFile.path,
                          //             )));
                        },
                        icon: Image.asset("assets/images/addvideo.png"),
                      ),
                      Text(
                        "Select Video",
                        style: TextStyle(color: Color(0xff87898A)),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),

             Column(
              children: [
                Container(
                  height: 300,
                  child: FutureBuilder(
                    future: video,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return AspectRatio(
                          aspectRatio: controller.value.aspectRatio,
                          child: VideoPlayer(controller),
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(height:100, child: dBMeter(maxDB)),
              ],
            ),
            // floatingActionButton: FloatingActionButton(
            //   onPressed: () {
            //     setState(() {
            //       if (_isPlaying) {
            //         _onPause();
            //         stop();
            //       } else {
            //         _onPlay();
            //         start();
            //       }
            //     });
            //   },
            //   child: Icon(
            //       controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
            // ),
          // ),
        ],
      ),
    );
  }

  Future<void> _onPause() async {
    controller.pause();
    setState(() {
      _isPlaying = false;
      stop();
    });
  }

  Future<void> _onPlay() async {
    if (!_isPlaying) {
      controller.play();
      setState(() {
        _isPlaying = true;
      });
    }
  }
}

class VideoDemo extends StatefulWidget {
  VideoDemo({super.key, required this.videoPath});

  final String videoPath;

  @override
  State<VideoDemo> createState() => VideoDemoState();
}

class VideoDemoState extends State<VideoDemo> {
  // variable for noise Reading
  bool isRecording = false;
  bool _isPlaying = false;
  StreamSubscription<NoiseReading>? noiseSubscription;
  late NoiseMeter noiseMeter;
  double maxDB = 0;
  double? meanDB;

  void onData(NoiseReading noiseReading) {
    setState(() {
      if (controller.value.isPlaying) {
        _isPlaying = true;
      } else {
        _isPlaying = false;
        stop();
      }
      // print("dataa: {$_isPlaying}");
    });
    maxDB = noiseReading.maxDecibel;
    meanDB = noiseReading.meanDecibel;
  }

  // error handle
  void onError(Object e) {
    isRecording = false;
  }

  void start() async {
    try {
      noiseSubscription = noiseMeter.noiseStream.listen(onData);
    } catch (e) {
      print(e);
    }
  }

  void stop() async {
    try {
      noiseSubscription!.cancel();
      noiseSubscription = null;

      // setState(() => {},);
    } catch (e) {
      print('stopRecorder error: $e');
    }
  }

  late VideoPlayerController controller;
  late Future<void> video;

  @override
  void initState() {
    super.initState();
    noiseMeter = NoiseMeter(onError);
    controller = VideoPlayerController.file(File(widget.videoPath));
    video = controller.initialize();
    controller.setLooping(false);
    controller.setVolume(1.0);
  }

  @override
  void dispose() {
    stop();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: video,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return AspectRatio(
                      aspectRatio: controller.value.aspectRatio,
                      child: VideoPlayer(controller),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            SizedBox(
              height: 25,
            ),
            dBMeter(maxDB),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              if (_isPlaying) {
                _onPause();
                stop();
              } else {
                _onPlay();
                start();
              }
            });
          },
          child:
              Icon(controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
        ),
      ),
    );
  }

  Future<void> _onPause() async {
    controller.pause();
    setState(() {
      _isPlaying = false;
      stop();
    });
  }

  Future<void> _onPlay() async {
    if (!_isPlaying) {
      controller.play();
      setState(() {
        _isPlaying = true;
      });
    }
  }
}*/

// import 'dart:async';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:dotted_border/dotted_border.dart';
// import 'package:video_player/video_player.dart';
// import 'package:noise_meter/noise_meter.dart';
//
// import '../utils/constants.dart';
//
// class Picker extends StatefulWidget {
//   const Picker({Key? key}) : super(key: key);
//
//   @override
//   State<Picker> createState() => _PickerState();
// }
//
// class _PickerState extends State<Picker> {
//   late PickedFile pickedFile;
//   final ImagePicker picker = ImagePicker();
//   bool _isPlaying = false;
//   bool _isRecording = false;
//   double _maxDB = 0;
//   double? _meanDB;
//
//   late VideoPlayerController controller;
//   late Future<void> video;
//
//   @override
//   void initState() {
//     super.initState();
//     controller = VideoPlayerController.asset('assets/videos/sample_video.mp4');
//     video = controller.initialize();
//     controller.setLooping(false);
//     controller.setVolume(1.0);
//   }
//
//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
//
//   void onData(NoiseReading noiseReading) {
//     setState(() {
//       if (controller.value.isPlaying) {
//         _isPlaying = true;
//       } else {
//         _isPlaying = false;
//         _onPause();
//         stop();
//       }
//       _maxDB = noiseReading.maxDecibel;
//       _meanDB = noiseReading.meanDecibel;
//     });
//   }
//
//   void onError(Object e) {
//     _isRecording = false;
//   }
//
//   void start() async {
//     try {
//       final NoiseMeter noiseMeter = NoiseMeter(onError);
//       final StreamSubscription<NoiseReading> noiseSubscription =
//           noiseMeter.noiseStream.listen(onData);
//       setState(() {
//         _isRecording = true;
//       });
//       await noiseSubscription.cancel();
//       setState(() {
//         _isRecording = false;
//       });
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   void stop() async {
//     try {
//       setState(() {
//         _isRecording = false;
//       });
//     } catch (e) {
//       print('stopRecorder error: $e');
//     }
//   }
//
//   Future<void> _onPause() async {
//     controller.pause();
//     setState(() {
//       _isPlaying = false;
//     });
//   }
//
//   Future<void> _onPlay() async {
//     if (!_isPlaying) {
//       controller.play();
//       setState(() {
//         _isPlaying = true;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: Padding(
//           padding: const EdgeInsets.only(left: 16.0),
//           child: IconButton(
//             icon: Image.asset(
//               'assets/images/back.png',
//               height: 28,
//               width: 28,
//             ),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//         ),
//         title: Padding(
//           padding: const EdgeInsets.only(left: 8.0),
//           child: Text(
//             "My Files",
//             style: kAppbarStyle,
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           Center(
//             child: GestureDetector(
//               onTap: () async {
//                 pickedFile =
//                     (await picker.getVideo(source: ImageSource.gallery))!;
//                 print("Pathh:${pickedFile.path}");
//                 setState(() {
//                   controller =
//                       VideoPlayerController.file(File(pickedFile.path));
//                   video = controller.initialize();
//                   controller.setLooping(false);
//                   controller.setVolume(1.0);
//                   _isPlaying = true;
//                   _onPlay();
//                   start();
//                 });
//               },
//               child: Padding(
//                 padding: const EdgeInsets.all(14.0),
//                 child: DottedBorder(
//                   borderType: BorderType.RRect,
//                   color: Color(0xffCED3D9),
//                   strokeWidth: 4,
//                   radius: Radius.circular(10),
//                   strokeCap: StrokeCap.butt,
//                   dashPattern: const [12, 15],
//                   child: Column(
//                     children: [
//                       Container(
//                         // height: 120,
//                         width: double.infinity,
//                         decoration: BoxDecoration(),
//                         child: _isPlaying
//                             ? AspectRatio(
//                                 aspectRatio: controller.value.aspectRatio,
//                                 child: VideoPlayer(controller),
//                               )
//                             : Column(
//                                 children: [
//                                   IconButton(
//                                     iconSize: 72,
//                                     onPressed: () async {
//                                       pickedFile = (await picker.getVideo(
//                                           source: ImageSource.gallery))!;
//                                       print("Pathh:${pickedFile.path}");
//                                       setState(() {
//                                         controller = VideoPlayerController.file(
//                                             File(pickedFile.path));
//                                         video = controller.initialize();
//                                         controller.setLooping(false);
//                                         controller.setVolume(1.0);
//                                         _isPlaying = true;
//                                         _onPlay();
//                                         start();
//                                       });
//                                     },
//                                     icon: Image.asset("assets/images/addvideo.png"),
//                                   ),
//                                   Text(
//                                     "Select Video",
//                                     style: TextStyle(color: Color(0xff87898A)),
//                                   )
//                                 ],
//                               ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(height: 25),
//           Text('Max DB: $_maxDB'),
//           Text('Mean DB: $_meanDB'),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           setState(() {
//             if (_isPlaying) {
//               _onPause();
//               stop();
//             } else {
//               _onPlay();
//               start();
//             }
//           });
//         },
//         child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jay_sound_meter/logic/dB_meter.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:video_player/video_player.dart';

import '../utils/constants.dart';

class PickFile extends StatefulWidget {
  const PickFile({super.key});

  @override
  State<PickFile> createState() => _PickFileState();
}

class _PickFileState extends State<PickFile> {
  bool isRecording = false;
  bool _isPlaying = false;
  StreamSubscription<NoiseReading>? noiseSubscription;
  late NoiseMeter noiseMeter;
  double maxDB = 0;
  double? meanDB;

  late VideoPlayerController controller;

  File? _image;
  final picker = ImagePicker();

  late Future<void> video;

  void onData(NoiseReading noiseReading) {
    setState(() {
      if (controller.value.isPlaying) {
        _isPlaying = true;
      } else {
        _isPlaying = false;
        stop();
      }
      // print("dataa: {$_isPlaying}");
    });
    setState(() {
      if (!isRecording) isRecording = true;
    });

    maxDB = noiseReading.maxDecibel;
    meanDB = noiseReading.meanDecibel;
  }

  // error handle
  void onError(Object e) {
    isRecording = false;
  }

  void start() async {
    try {
      noiseSubscription = noiseMeter.noiseStream.listen(onData);
    } catch (e) {
      print(e);
    }
  }

  void stop() async {
    try {
      noiseSubscription!.cancel();
      noiseSubscription = null;

      // setState(() => {},);
    } catch (e) {
      print('stopRecorder error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    noiseMeter = NoiseMeter(onError);
  }

  @override
  void dispose() {
    stop();
    controller.dispose();
    super.dispose();
  }

  // This funcion will helps you to pick and Image from Gallery
  _pickImageFromGallery() async {
    PickedFile? pickedFile = await picker.getVideo(
      source: ImageSource.gallery,
    );

    File image = File(pickedFile!.path);

    setState(() {
      _image = image;
      controller = VideoPlayerController.file(File(_image!.path));
      video = controller.initialize();
      controller.setLooping(false);
      controller.setVolume(1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: IconButton(
              icon: Image.asset(
                'assets/images/back.png',
                height: 28,
                width: 28,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              "My Files",
              style: kAppbarStyle,
            ),
          ),
        ),

        floatingActionButton: _image != null
            ? FloatingActionButton(
                onPressed: () {
                  setState(() {
                    // if (_isPlaying) {
                    //   _onPause();
                    //   stop();
                    // } else {
                    //   _onPlay();
                    //   start();
                    // }
                    if (controller.value.isPlaying) {
                      controller.pause();
                      stop();
                    } else {
                      controller.play();
                      start();
                    }
                  });
                },
                child: Icon(controller.value.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow))
            : SizedBox.shrink(),
        body: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // ElevatedButton(
                //   onPressed: () {
                //     _pickImageFromGallery();
                //     // or
                //     // _pickImageFromCamera();
                //     // use the variables accordingly
                //   },
                //   child: Text("Pick Image From Gallery"),
                // ),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: GestureDetector(
                    onTap: () {
                      _pickImageFromGallery();
                    },
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      color: Color(0xffCED3D9),
                      strokeWidth: 3.25,
                      radius: const Radius.circular(10),
                      strokeCap: StrokeCap.butt,
                      dashPattern: const [12, 15],
                      child: Column(
                        children: [
                          Container(
                            // height: 120,
                            width: double.infinity,
                            decoration: BoxDecoration(),
                            child: Column(
                              children: [
                                IconButton(
                                  iconSize: 60,
                                  onPressed: () {
                                    _pickImageFromGallery();
                                  },
                                  icon: Image.asset("assets/images/addvideo.png"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    "Select Video",
                                    style: TextStyle(color: Color(0xff87898A)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (_image != null)
                  Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6.0, horizontal: 16),
                          child: Container(
                            // height: 450,
                            child: FutureBuilder(
                              future: video,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return AspectRatio(
                                    aspectRatio: 4/5,
                                    child: VideoPlayer(controller),
                                  );
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                        _image != null ? Container(height: 350,child: dBMeter(maxDB)) : SizedBox.shrink()
                      ],
                    ),
                  )
                else
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Text(
                        "Click on Select Video to select a Video",
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ]),
        ),
      ),
    );
  }

  Future<void> _onPause() async {
    controller.pause();
    setState(() {
      _isPlaying = false;
      stop();
    });
  }

  Future<void> _onPlay() async {
    if (!_isPlaying) {
      controller.play();
      setState(() {
        _isPlaying = true;
      });
    }
  }
}
