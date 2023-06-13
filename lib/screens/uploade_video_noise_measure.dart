import 'dart:async';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jay_sound_meter/logic/dB_meter.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:video_player/video_player.dart';

enum DataSourceType {
  assets,
  network,
  file,
  contentUri,
}

class UploadedVideoNoiseMeasure extends StatelessWidget {
  const UploadedVideoNoiseMeasure({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Camera Noise Measure'),
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
  bool isRecording = false;
  StreamSubscription<NoiseReading>? noiseSubscription;
  late NoiseMeter noiseMeter;
  double maxDB = 0;
  double? meanDB;

  @override
  void initState() {
    super.initState();
    noiseMeter = NoiseMeter(onError);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    stop();
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          dBMeter(maxDB),
          SizedBox(
            height: 24,
          ),
          SelectVideo(),
        ],
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onDoubleTap: () {},
            child: FloatingActionButton.extended(
              label: Text(isRecording ? 'Stop' : 'Start'),
              onPressed: isRecording ? stop : start,
              icon: !isRecording
                  ? const Icon(Icons.not_started_sharp)
                  : const Icon(Icons.stop_circle_sharp),
              backgroundColor: isRecording ? Colors.red : Colors.green,
            ),
          ),
        ],
      ),
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

class VideoPlayerViewState extends State<VideoPlayerView> {
  late List<VideoPlayerController> _videoPlayerControllers;
  late List<ChewieController> _chewieControllers;

  @override
  void initState() {
    super.initState();

    _videoPlayerControllers = [];
    _chewieControllers = [];

    for (final file in widget.files) {
      VideoPlayerController videoPlayerController =
          VideoPlayerController.file(file);
      _videoPlayerControllers.add(videoPlayerController);

      ChewieController chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        aspectRatio: videoPlayerController.value.aspectRatio,
      );
      _chewieControllers.add(chewieController);

      videoPlayerController.initialize().then((_) {
        setState(() {});
      });
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.dataSourceType.toString().split('.').last.toUpperCase(),
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const Divider(),
        for (var i = 0; i < widget.files.length; i++)
          _videoPlayerControllers[i].value.isInitialized
              ? AspectRatio(
                  aspectRatio: _videoPlayerControllers[i].value.aspectRatio,
                  child: Chewie(
                    controller: _chewieControllers[i],
                  ),
                )
              : const SizedBox.shrink(),
      ],
    );
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
        TextButton(
          onPressed: () async {
            final file =
                await ImagePicker().pickVideo(source: ImageSource.gallery);
            if (file != null) {
              setState(() {
                _files.add(File(file.path));
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
