import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:jay_sound_meter/logic/dB_Data.dart';
import 'package:jay_sound_meter/logic/dB_meter.dart';
import 'package:jay_sound_meter/logic/dB_record_data.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:noise_meter/noise_meter.dart';

import 'noise_detector.dart';

class RecordListView extends StatefulWidget {
  final List<String> records;
  final Directory appDirectory;

  const RecordListView({
    Key? key,
    required this.records,
    required this.appDirectory,
  }) : super(key: key);

  @override
  _RecordListViewState createState() =>
      _RecordListViewState(records: records, appDirectory: appDirectory);
}

class _RecordListViewState extends State<RecordListView>
    with WidgetsBindingObserver {
  _RecordListViewState({required this.records, required this.appDirectory});

  // variables for noise recording
  bool isRecording = false;
  StreamSubscription<NoiseReading>? noiseSubscription;
  late NoiseMeter noiseMeter;
  double maxDB = 0;
  double? meanDB;

  final Directory appDirectory;

  List<String> records;
  late int _totalDuration;
  late int _currentDuration;
  double _completedPercentage = 0.0;
  bool _isPlaying = false;
  int _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    noiseMeter = NoiseMeter(onError);
  }

  @override
  void dispose() {
    super.dispose();
    stop();
  }

  //method for taking noise data
  void onData(NoiseReading noiseReading) {
    setState(() {
      if (!isRecording) isRecording = true;
    });
    maxDB = noiseReading.maxDecibel;
    meanDB = noiseReading.meanDecibel;
  }

  // error handle
  void onError(Object e) {
    if (kDebugMode) {
      print(e.toString());
    }
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
      if (kDebugMode) {
        print('stopRecorder error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.records.isEmpty
        ? const Center(
            child: Text(
              'No records yet',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              color: Colors.blue.shade50,
              child: ListView.builder(
                itemCount: widget.records.length,
                shrinkWrap: true,
                reverse: false,
                itemBuilder: (BuildContext context, int i) {
                  return ExpansionTile(
                    // this new index is for getting new recording first
                    title: Text('New recoding ${widget.records.length - i}'),
                    subtitle: Text(_getDateFromFilePath(
                        filePath: widget.records.elementAt(i))),
                    onExpansionChanged: ((newState) {
                      if (newState) {
                        setState(
                          () {
                            _selectedIndex = i;
                          },
                        );
                      }
                    }),
                    children: [
                      // dropDown container
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LinearProgressIndicator(
                              minHeight: 5,
                              backgroundColor: Colors.black,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.green.shade500),
                              value: _selectedIndex == i
                                  ? _completedPercentage
                                  : 0,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: _selectedIndex == i
                                      ? _isPlaying
                                          ? const Icon(
                                              Icons.pause,
                                              size: 30,
                                            )
                                          : Icon(Icons.play_arrow, size: 30)
                                      : Icon(Icons.play_arrow, size: 30),
                                  onPressed: () {
                                    if (_isPlaying) {
                                      _onPause();
                                    } else {
                                      _onPlay(
                                          filePath: widget.records.elementAt(i),
                                          index: i);
                                    }
                                  },
                                ),
                                IconButton(
                                    onPressed: () {
                                      _onStop();
                                    },
                                    icon: const Icon(
                                      Icons.stop_circle_rounded,
                                      size: 30,
                                      color: Colors.red,
                                    )),
                                IconButton(
                                    onPressed: () {
                                      deleteFile(
                                          File(widget.records.elementAt(i)), i);
                                      setState(() {});
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      size: 30,
                                      color: Colors.red.shade900,
                                    )),

                                GestureDetector(
                                  onDoubleTap: () {},
                                  child: FloatingActionButton.extended(
                                    label: Text(isRecording ? '' : ''),
                                    onPressed: isRecording ? stop : start,
                                    icon: !isRecording
                                        ? const Icon(Icons.record_voice_over_sharp)
                                        : const Icon(Icons.stop),
                                  ),
                                ),

                                // IconButton(
                                //     onPressed: () {
                                //       isRecording ? stop : start;
                                //     },
                                //     icon: Icon(
                                //       Icons.record_voice_over_sharp,
                                //       size: 30,
                                //       color: Colors.blue.shade500,
                                //     )),
                              ],
                            ),
                            dBMeter(maxDB),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
  }

  Future<void> deleteFile(File file, int index) async {
    try {
      if (await file.exists()) {
        await file.delete();
        setState(() {
          records.remove(file);
          widget.records
              .removeAt(index); // Remove the deleted file from the list
        });
        print("delete");
      } else {
        print("File not exist");
      }
    } catch (e) {
      print("not delete");
      // Error in getting access to the file.
    }
    setState(() {});
  }

  AudioPlayer audioPlayer = AudioPlayer();

  Future<void> _onPlay({required String filePath, required int index}) async {
    if (!_isPlaying) {
      audioPlayer.play(filePath, isLocal: true);
      setState(() {
        _selectedIndex = index;
        _completedPercentage = 0.0;
        _isPlaying = true;
      });

      audioPlayer.onPlayerCompletion.listen((_) {
        setState(() {
          _isPlaying = false;
          _completedPercentage = 0.0;
        });
      });

      audioPlayer.onDurationChanged.listen((duration) {
        setState(() {
          _totalDuration = duration.inMicroseconds;
        });
      });

      audioPlayer.onAudioPositionChanged.listen((duration) {
        setState(() {
          _currentDuration = duration.inMicroseconds;
          _completedPercentage =
              _currentDuration.toDouble() / _totalDuration.toDouble();
        });
      });
    }
  }

  Future<void> _onStop() async {
    audioPlayer.stop();
    setState(() {
      _isPlaying = false;
      _completedPercentage = 0.0;
    });
  }

  Future<void> _onPause() async {
    audioPlayer.pause();
    setState(() {
      _isPlaying = false;
    });
  }

  // Future<void> _onDelete(List<String> records, int index) async {
  //   records.removeAt(index);
  //   setState(() {
  //     _isPlaying = false;
  //   });
  // }

  String _getDateFromFilePath({required String filePath}) {
    print("Path:${filePath}");
    String fromEpoch = filePath.substring(
        filePath.lastIndexOf('/') + 1, filePath.lastIndexOf('.'));

    DateTime recordedDate =
        DateTime.fromMillisecondsSinceEpoch(int.parse(fromEpoch));
    int year = recordedDate.year;
    int month = recordedDate.month;
    int day = recordedDate.day;

    return ('$day-$month-$year');
  }
}
