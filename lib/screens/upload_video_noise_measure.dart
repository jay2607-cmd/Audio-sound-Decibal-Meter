// import 'dart:async';
// import 'dart:io';
//
// import 'package:chewie/chewie.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:jay_sound_meter/logic/dB_meter.dart';
// import 'package:noise_meter/noise_meter.dart';
// import 'package:video_player/video_player.dart';
//
// enum DataSourceType {
//   file,
// }
//
// // root widget
// class UploadedVideoNoiseMeasure extends StatelessWidget
//     with WidgetsBindingObserver {
//   const UploadedVideoNoiseMeasure({Key? key}) : super(key: key);
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: const MyHomePage(title: 'Camera Noise Measure'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
//   VideoPlayerViewState videoPlayerViewState = VideoPlayerViewState();
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     videoPlayerViewState.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//         centerTitle: true,
//       ),
//       body: ListView(
//         padding: EdgeInsets.all(20),
//         children: [
//           // dBMeter(maxDB),
//           // SizedBox(
//           //   height: 24,
//           // ),
//           SelectVideo(),
//         ],
//       ),
//     );
//   }
// }
//
// class VideoPlayerView extends StatefulWidget {
//   const VideoPlayerView({
//     Key? key,
//     required this.files,
//     required this.dataSourceType,
//   }) : super(key: key);
//
//   final List<File> files;
//   final DataSourceType dataSourceType;
//
//   @override
//   State<StatefulWidget> createState() {
//     return VideoPlayerViewState();
//   }
// }
//
// class VideoPlayerViewState extends State<VideoPlayerView>
//     with WidgetsBindingObserver {
//   bool isRecording = false;
//   StreamSubscription<NoiseReading>? noiseSubscription;
//   late NoiseMeter noiseMeter;
//   double maxDB = 0;
//   double? meanDB;
//
//   void onData(NoiseReading noiseReading) {
//     setState(() {
//       if (!isRecording) isRecording = true;
//     });
//     maxDB = noiseReading.maxDecibel;
//     meanDB = noiseReading.meanDecibel;
//   }
//
//   // error handle
//   void onError(Object e) {
//     isRecording = false;
//   }
//
//   void start() async {
//     try {
//       noiseSubscription = noiseMeter.noiseStream.listen(onData);
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   void stop() async {
//     try {
//       noiseSubscription!.cancel();
//       noiseSubscription = null;
//
//       setState(() => isRecording = false);
//     } catch (e) {
//       print('stopRecorder error: $e');
//     }
//   }
//
//   late List<VideoPlayerController> _videoPlayerControllers;
//   late List<ChewieController> _chewieControllers;
//
//   late VideoPlayerController videoPlayerController;
//
//   @override
//   void initState() {
//     super.initState();
//     noiseMeter = NoiseMeter(onError);
//
//     WidgetsBinding.instance.addObserver(this);
//     _videoPlayerControllers = [];
//     _chewieControllers = [];
//
//     for (final file in widget.files) {
//       videoPlayerController = VideoPlayerController.file(file);
//       _videoPlayerControllers.add(videoPlayerController);
//       ChewieController chewieController = ChewieController(
//         fullScreenByDefault: false,
//         videoPlayerController: videoPlayerController,
//         aspectRatio: videoPlayerController.value.aspectRatio,
//       );
//       _chewieControllers.add(chewieController);
//       videoPlayerController.initialize().then(
//         (_) {
//           setState(() {
//             videoPlayerController.addListener(() {
//               if (!videoPlayerController.value.isPlaying &&
//                   videoPlayerController.value.isInitialized &&
//                   (videoPlayerController.value.duration ==
//                       videoPlayerController.value.position)) {
//                 //checking the duration and position every time
//                 print("if 1");
//                 start();
//               } else {
//                 print("else 1");
//                 stop();
//               }
//
//               if (videoPlayerController.value.isPlaying) {
//                 print("if 2");
//                 start();
//               } else if (!videoPlayerController.value.isPlaying) {
//                 stop();
//               }
//             });
//           });
//
//           // videoPlayerController.addListener(() {
//           //   //custom Listner
//           //   setState(() {
//           //     // print(
//           //     //     "videoPlayerController.isPlaying 2 : ${videoPlayerController.value.isPlaying}");
//           //     // print(
//           //     //     "chewieController.isPlaying 2 : ${chewieController.isPlaying}");
//           //
//           //     if (!videoPlayerController.value.isPlaying &&
//           //         videoPlayerController.value.isInitialized &&
//           //         (videoPlayerController.value.duration ==
//           //             videoPlayerController.value.position)) {
//           //       //checking the duration and position every time
//           //       print("if 1");
//           //         start();
//           //     } else {
//           //       print("else 1");
//           //       stop();
//           //     }
//           //
//           //     if (videoPlayerController.value.isPlaying) {
//           //       print("if 2");
//           //       start();
//           //     } else if (!videoPlayerController.value.isPlaying) {
//           //       stop();
//           //     }
//           //     // else if(!chewieController.isPlaying){
//           //     //    print(videoPlayerController.value.isPlaying);
//           //     //    stop();
//           //     //  }
//           //   },);
//           // },);
//           // print("chewieController.isPlaying 2 : ${chewieController.isPlaying}");
//
//           // _videoPlayerControllers[_videoPlayerControllers.length-1].pause();
//           // print("chewieController.isPlaying 2 : ${chewieController.isPlaying}");
//           // _videoPlayerControllers[_videoPlayerControllers.length-1].play();
//           // print("chewieController.isPlaying : ${chewieController.isPlaying}");
//         },
//       );
//
//       if (file != widget.files[widget.files.length - 1]) {
//         videoPlayerController.pause();
//       }
//       // print("chewieController.isPlaying 3 : ${chewieController.isPlaying}");
//     }
//   }
//
//   @override
//   void dispose() {
//     for (final chewieController in _chewieControllers) {
//       chewieController.dispose();
//     }
//     for (final videoPlayerController in _videoPlayerControllers) {
//       videoPlayerController.dispose();
//     }
//     videoPlayerController.removeListener(() {
//       // stop();
//     });
//     isRecording = false;
//     stop();
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: buildChildren(),
//         ),
//         dBMeter(maxDB),
//       ],
//     );
//   }
//
//   List<Widget> buildChildren() {
//     List<Widget> children = [
//       Text(
//         widget.dataSourceType.toString().split('.').last.toUpperCase(),
//         style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//       ),
//       const Divider(),
//     ];
//
//     for (var i = 0; i < widget.files.length; i++) {
//       if (_videoPlayerControllers[i].value.isInitialized) {
//         children.add(
//           AspectRatio(
//             aspectRatio: _videoPlayerControllers[i].value.aspectRatio,
//             child: Chewie(
//               controller: _chewieControllers[i],
//             ),
//           ),
//         );
//         // if(_videoPlayerControllers[i].value.isPlaying) {
//         //   start();
//         // }
//         // else{
//         //   // stop it
//         //   stop();
//         // }
//       } else {
//         const SizedBox.shrink();
//       }
//     }
//
//     return children;
//   }
// }
//
// class SelectVideo extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return SelectVideoState();
//   }
// }
//
// class SelectVideoState extends State<SelectVideo> {
//   List<File> _files = [];
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         ElevatedButton(
//           onPressed: () async {
//             // _files.removeAt(0);
//             _files.clear();
//             _files = [];
//             final file =
//                 await ImagePicker().pickVideo(source: ImageSource.gallery);
//             if (file != null) {
//               print("Picker ${file.path}");
//               setState(() {
//                 // if (_files.isEmpty) {
//                 if(_files.isNotEmpty) {
//                   _files.removeAt(0);
//                   _files.clear();
//                 }
//                 _files.add(File(file.path));
//                 // }
//                 // else {
//                 //   print("1st ${_files.length}");
//                 //   _files.remove(_files.length - 1);
//                 //   // print("2nd ${_files.length - 1}");
//                 //   _files.add(File(file.path));
//                 //   // print("3rd ${_files.length}");
//                 // }
//               });
//             }
//           },
//           child: const Text("Select Video"),
//         ),
//         for (final file in _files) playVideo(file, _files),
//       ],
//     );
//   }
// }
//
// Widget playVideo(File file, List<File> files) {
//   print("PlayVideoLength: ${files.length}");
//   return VideoPlayerView(
//     files: [file],
//     dataSourceType: DataSourceType.file,
//   );
// }
// /*
//
// import 'dart:async';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:jay_sound_meter/logic/dB_meter.dart';
// import 'package:noise_meter/noise_meter.dart';
// import 'package:video_player/video_player.dart';
//
// class VideoDemo extends StatefulWidget {
//   VideoDemo({super.key, required this.videoPath});
//   final String videoPath;
//
//   @override
//   State<VideoDemo> createState() => VideoDemoState();
// }
//
// class VideoDemoState extends State<VideoDemo> {
//   // variable for noise Reading
//   bool isRecording = false;
//   bool _isPlaying = false;
//   StreamSubscription<NoiseReading>? noiseSubscription;
//   late NoiseMeter noiseMeter;
//   double maxDB = 0;
//   double? meanDB;
//
//   void onData(NoiseReading noiseReading) {
//     setState(() {
//       if (controller.value.isPlaying) {
//         _isPlaying = true;
//       } else {
//         _isPlaying = false;
//         stop();
//       }
//       // print("dataa: {$_isPlaying}");
//     });
//     maxDB = noiseReading.maxDecibel;
//     meanDB = noiseReading.meanDecibel;
//   }
//
//   // error handle
//   void onError(Object e) {
//     isRecording = false;
//   }
//
//   void start() async {
//     try {
//       noiseSubscription = noiseMeter.noiseStream.listen(onData);
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   void stop() async {
//     try {
//       noiseSubscription!.cancel();
//       noiseSubscription = null;
//
//       // setState(() => {},);
//     } catch (e) {
//       print('stopRecorder error: $e');
//     }
//   }
//
//   late VideoPlayerController controller;
//   late Future<void> video;
//
//   @override
//   void initState() {
//     super.initState();
//     noiseMeter = NoiseMeter(onError);
//     controller = VideoPlayerController.file(File(widget.videoPath));
//     video = controller.initialize();
//     controller.setLooping(false);
//     controller.setVolume(1.0);
//   }
//
//   @override
//   void dispose() {
//     stop();
//     controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Column(
//           children: [
//             Expanded(
//               child: FutureBuilder(
//                 future: video,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.done) {
//                     return AspectRatio(
//                       aspectRatio: controller.value.aspectRatio,
//                       child: VideoPlayer(controller),
//                     );
//                   } else {
//                     return Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   }
//                 },
//               ),
//             ),
//             SizedBox(
//               height: 25,
//             ),
//             dBMeter(maxDB),
//           ],
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             setState(() {
//               if (_isPlaying) {
//                 _onPause();
//                 stop();
//               } else {
//                 _onPlay();
//                 start();
//               }
//             });
//           },
//           child:
//               Icon(controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
//         ),
//       ),
//     );
//   }
//
//   Future<void> _onPause() async {
//     controller.pause();
//     setState(() {
//       _isPlaying = false;
//       stop();
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
// }
// */
