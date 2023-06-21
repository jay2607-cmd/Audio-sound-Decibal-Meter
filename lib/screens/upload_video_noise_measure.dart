import 'dart:async';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jay_sound_meter/logic/dB_meter.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:video_player/video_player.dart';

enum DataSourceType {
  file,
}

late List<VideoPlayerController> _videoPlayerControllers;
late List<ChewieController> _chewieControllers;

void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  
}

// root widget
class UploadedVideoNoiseMeasure extends StatelessWidget with WidgetsBindingObserver{
  const UploadedVideoNoiseMeasure({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const MyHomePage(title: 'Camera Noise Measure'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  // //for measuring noise
  // bool isRecording = false;
  // StreamSubscription<NoiseReading>? noiseSubscription;
  // late NoiseMeter noiseMeter;
  // double maxDB = 0;
  // double? meanDB;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   noiseMeter = NoiseMeter(onError);
  //   WidgetsBinding.instance.addObserver(this);
  // }
  //
  // @override
  // void dispose() {
  //   super.dispose();
  //   stop();
  // }
  //
  // void onData(NoiseReading noiseReading) {
  //   setState(() {
  //     if (!isRecording) isRecording = true;
  //   });
  //   maxDB = noiseReading.maxDecibel;
  //   meanDB = noiseReading.meanDecibel;
  // }
  //
  // // error handle
  // void onError(Object e) {
  //   isRecording = false;
  // }
  //
  // void start() async {
  //   try {
  //     noiseSubscription = noiseMeter.noiseStream.listen(onData);
  //   } catch (e) {
  //     print(e);
  //   }
  // }
  //
  // void stop() async {
  //   try {
  //     noiseSubscription!.cancel();
  //     noiseSubscription = null;
  //
  //     setState(() => isRecording = false);
  //   } catch (e) {
  //     print('stopRecorder error: $e');
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // actions: [
        //   ElevatedButton(onPressed: () {
        //     setState(() {
        //       _chewieControllers.removeRange(0, _chewieControllers.length-1);
        //       _videoPlayerControllers.removeRange(0, _videoPlayerControllers.length-1);
        //     });
        //   }, child: Text("Delete All"))
        // ],
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          // dBMeter(maxDB),
          // SizedBox(
          //   height: 24,
          // ),


          SelectVideo(),

        ],
      ),
      // floatingActionButtonLocation:
      //     FloatingActionButtonLocation.miniCenterFloat,
      // floatingActionButton: Row(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
          // GestureDetector(
          //   onDoubleTap: () {},
          //   child: FloatingActionButton.extended(
          //     label: Text(isRecording ? 'Stop' : 'Start'),
          //     onPressed: isRecording ? stop : start,
          //     icon: !isRecording
          //         ? const Icon(Icons.not_started_sharp)
          //         : const Icon(Icons.stop_circle_sharp),
          //     backgroundColor: isRecording ? Colors.red : Colors.green,
          //   ),
          // ),
        // ],
      // ),
    );
  }
}

class VideoPlayerView extends StatefulWidget {
  const VideoPlayerView({
    Key? key,
    required this.files,
    required this.dataSourceType,
  }) : super(key: key);

  final List<File> files;
  final DataSourceType dataSourceType;

  @override
  State<StatefulWidget> createState() {
    return VideoPlayerViewState();
  }
}

class VideoPlayerViewState extends State<VideoPlayerView>
    with WidgetsBindingObserver {
  bool isRecording = false;
  StreamSubscription<NoiseReading>? noiseSubscription;
  late NoiseMeter noiseMeter;
  double maxDB = 0;
  double? meanDB;

  void onData(NoiseReading noiseReading) {
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

      setState(() => isRecording = false);
    } catch (e) {
      print('stopRecorder error: $e');
    }
  }


  @override
  void initState() {
    super.initState();
    noiseMeter = NoiseMeter(onError);
    WidgetsBinding.instance.addObserver(this);
    _videoPlayerControllers = [];
    _chewieControllers = [];

    for (final file in widget.files) {
      VideoPlayerController videoPlayerController =
          VideoPlayerController.file(file);
      _videoPlayerControllers.add(videoPlayerController);
      ChewieController chewieController = ChewieController(
        fullScreenByDefault: false,
        videoPlayerController: videoPlayerController,
        aspectRatio: videoPlayerController.value.aspectRatio,
      );
      _chewieControllers.add(chewieController);
      videoPlayerController.initialize().then((_) {
        setState(() {});

        videoPlayerController.addListener(() {
          //custom Listner
          setState(() {
            print(
                "videoPlayerController.isPlaying 2 : ${videoPlayerController.value.isPlaying}");
            print(
                "chewieController.isPlaying 2 : ${chewieController.isPlaying}");

            if (!videoPlayerController.value.isPlaying &&
                videoPlayerController.value.isInitialized &&
                (videoPlayerController.value.duration ==
                    videoPlayerController.value.position)) {
              //checking the duration and position every time

              setState(() {
                start();
              });
            } else {
              stop();
            }

            if (videoPlayerController.value.isPlaying) {
              start();
            } else if (!videoPlayerController.value.isPlaying) {
              stop();
            }
            // else if(!chewieController.isPlaying){
            //    print(videoPlayerController.value.isPlaying);
            //    stop();
            //  }
          });
        });
        // print("chewieController.isPlaying 2 : ${chewieController.isPlaying}");

        // _videoPlayerControllers[_videoPlayerControllers.length-1].pause();
        // print("chewieController.isPlaying 2 : ${chewieController.isPlaying}");
        // _videoPlayerControllers[_videoPlayerControllers.length-1].play();
        // print("chewieController.isPlaying : ${chewieController.isPlaying}");
      });

      if (file != widget.files[widget.files.length - 1]) {
        videoPlayerController.pause();
      }
      // print("chewieController.isPlaying 3 : ${chewieController.isPlaying}");
    }
  }

  @override
  void dispose() {
    for (final chewieController in _chewieControllers) {
      chewieController.dispose();
    }
    for (final videoPlayerController in _videoPlayerControllers) {
      videoPlayerController.dispose();
    }
    stop();
    super.dispose();
  }

  // additional chatGpt function
  void playPause(int index) {
    if (_chewieControllers[index].videoPlayerController.value.isPlaying) {
      _chewieControllers[index].pause();
    } else {
      _chewieControllers[index].play();
    }
  }

  @override
  // Widget build(BuildContext context) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         widget.dataSourceType.toString().split('.').last.toUpperCase(),
  //         style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  //       ),
  //       const Divider(),
  //       for (var i = 0; i < widget.files.length; i++)
  //         if (_videoPlayerControllers[i].value.isInitialized)
  //           AspectRatio(
  //             aspectRatio: _videoPlayerControllers[i].value.aspectRatio,
  //             child: Chewie(
  //               controller: _chewieControllers[i],
  //             ),
  //           )
  //         else
  //           // print(_videoPlayerControllers[i].value.isPlaying),
  //           Text("video value : ${_videoPlayerControllers[i].value.isPlaying}"),
  //     ],
  //   );
  // }
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: buildChildren(),
        ),
        dBMeter(maxDB),
      ],
    );
  }

  List<Widget> buildChildren() {
    List<Widget> children = [
      Text(
        widget.dataSourceType.toString().split('.').last.toUpperCase(),
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      const Divider(),
    ];

    for (var i = 0; i < widget.files.length; i++) {
      if (_videoPlayerControllers[i].value.isInitialized) {
        children.add(
          AspectRatio(
            aspectRatio: _videoPlayerControllers[i].value.aspectRatio,
            child: Chewie(
              controller: _chewieControllers[i],
            ),
          ),
        );
        // if(_videoPlayerControllers[i].value.isPlaying) {
        //   start();
        // }
        // else{
        //   // stop it
        //   stop();
        // }
      } else {
        const SizedBox.shrink();
      }
    }

    return children;
  }
}

class SelectVideo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SelectVideoState();
  }
}

class SelectVideoState extends State<SelectVideo> {
  List<File> _files = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            final file =
                await ImagePicker().pickVideo(source: ImageSource.gallery);
            if (file != null) {
              print("Picker ${file.path}");
              setState(() {
                if (_files.isEmpty) {
                  _files.add(File(file.path));
                } else {
                  print("1st ${_files.length}");
                  _files.remove(_files.length - 1);
                  // print("2nd ${_files.length - 1}");
                  _files.add(File(file.path));
                  // print("3rd ${_files.length}");
                }
              });
            }
          },
          child: const Text("Select Video"),
        ),
        for (final file in _files)
          VideoPlayerView(
            files: [file],
            dataSourceType: DataSourceType.file,
          ),
      ],
    );
  }
}
