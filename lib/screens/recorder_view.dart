import 'dart:io';
import 'package:flutter/material.dart';
import 'package:jay_sound_meter/screens/noise_detector.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';

class RecorderView extends StatefulWidget {
  final Function onSaved;

  const RecorderView({Key? key, required this.onSaved}) : super(key: key);
  @override
  _RecorderViewState createState() => _RecorderViewState();
}

// different states of recordings
enum RecordingState {
  UnSet,
  Set,
  Recording,
  Stopped,
}

class _RecorderViewState extends State<RecorderView> {
  IconData _recordIcon = Icons.mic_none;
  String _recordText = 'Click To Start';

  // RecordingState - Inbulid variable for handling recording's state
  RecordingState _recordingState = RecordingState.UnSet;

  //  Recorder properties
  late FlutterAudioRecorder2 audioRecorder;

  @override
  void initState() {
    super.initState();

    FlutterAudioRecorder2.hasPermissions.then(
      (hasPermision) {
        if (hasPermision!) {
          _recordingState = RecordingState.Set;
          _recordIcon = Icons.mic;
          _recordText = 'Record';
        }
      },
    );
  }

  @override
  void dispose() {
    _recordingState = RecordingState.UnSet;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              color: Colors.blue.shade100,
              onPressed: () async {
                await _onRecordButtonPressed();
                setState(() {});
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              child: Container(
                width: 70,
                height: 70,
                child: Icon(
                  _recordIcon,
                  size: 50,
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            MaterialButton(
              color: Colors.red.shade200,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NoiseDetector()));
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              child: Container(
                width: 70,
                height: 70,
                child: Icon(
                  Icons.directions,
                  size: 50,
                ),
              ),
            ),
          ],
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              child: Text(_recordText),
              padding: const EdgeInsets.all(8),
            ))
      ],
    );
  }

  Future<void> _onRecordButtonPressed() async {
    switch (_recordingState) {
      case RecordingState.Set:
        await _recordVoice();
        break;

      case RecordingState.Recording:
        await _stopRecording();
        _recordingState = RecordingState.Stopped;
        _recordIcon = Icons.mic_none_sharp;
        _recordText = 'Record a new one';
        break;

      case RecordingState.Stopped:
        await _recordVoice();
        break;

      case RecordingState.UnSet:
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please allow recording from settings.'),
        ));
        break;
    }
  }

  _initRecorder() async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String filePath = appDirectory.path +
        '/' +
        DateTime.now().millisecondsSinceEpoch.toString() +
        '.aac';
    print(filePath);
    audioRecorder =
        FlutterAudioRecorder2(filePath, audioFormat: AudioFormat.AAC);

    await audioRecorder.initialized;
  }

  _startRecording() async {
    await audioRecorder.start();
    // await audioRecorder.current(channel: 0);
  }

  _stopRecording() async {
    await audioRecorder.stop();

    widget.onSaved();
  }

  Future<void> _recordVoice() async {
    final hasPermission = await FlutterAudioRecorder2.hasPermissions;

    /// if hasPermission is not null then returns hasPermission , otherwise returns null
    if (hasPermission ?? false) {
      await _initRecorder();

      await _startRecording();
      _recordingState = RecordingState.Recording;
      _recordIcon = Icons.stop;
      _recordText = 'Recording';
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please allow recording from settings.'),
        ),
      );
    }
  }
}


