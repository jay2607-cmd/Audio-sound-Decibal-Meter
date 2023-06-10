import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:jay_sound_meter/logic/dB_meter.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:noise_meter/noise_meter.dart';

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

  TextEditingController renameController = TextEditingController();

  bool isRenamePressed = false;

  // variables for noise recording
  bool isRecording = false;
  StreamSubscription<NoiseReading>? noiseSubscription;
  late NoiseMeter noiseMeter;
  double maxDB = 0;
  double? meanDB;

  final stat = FileStat.statSync("test.dart");

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

  Future<File> changeFileNameOnly(File file, String newFileName) {
    var path = file.path;
    var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
    var newPath = path.substring(0, lastSeparator + 1) + newFileName;
    print("new path: ${newPath}");
    return file.rename(newPath);
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
                  File file = new File(widget.records.elementAt(i));
                  String fileName = file.path.split('/').last;

                  // print("File Name:${renameController}");
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: ExpansionTile(
                      // this new index is for getting new recording first
                      // title: Text('New recoding ${widget.records.length - i}'),
                      title: Text(fileName),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Accessed: ${stat.modified}'),
                          // // SizedBox(height: 5),
                          // Text(
                          //     "Time : ${_getTimeFromFilePath(filePath: widget.records.elementAt(i))} "),
                        ],
                      ),

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
                                            filePath:
                                                widget.records.elementAt(i),
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
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Warning!',
                                                  style: TextStyle(
                                                      color: Colors.red)),
                                              content: const Text(
                                                  'Are you really want to delete this file!'),
                                              actions: [
                                                TextButton(
                                                  child: Text('Cancel'),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text('OK'),
                                                  onPressed: () {
                                                    deleteFile(
                                                        File(widget.records
                                                            .elementAt(i)),
                                                        i);
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );

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
                                      shape: const CircleBorder(),
                                      elevation: 0,
                                      backgroundColor: Colors.blue.shade50,
                                      foregroundColor: Colors.blue.shade500,
                                      label: const Text(''),
                                      onPressed: isRecording ? stop : start,
                                      icon: !isRecording
                                          ? const Icon(
                                              Icons.record_voice_over_sharp,
                                              size: 30,
                                            )
                                          : const Icon(
                                              Icons.stop,
                                              size: 30,
                                              color: Colors.red,
                                            ),
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Rename!',
                                                  style: TextStyle(
                                                      color: Colors.blue)),
                                              content: const Text(
                                                  'Are you really want to rename this file!'),
                                              actions: [
                                                TextField(
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.blue),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    hintText: 'Enter New Name',
                                                    helperText:
                                                        'Keep it meaningful',
                                                    labelText: 'Rename',
                                                    prefixIcon: const Icon(
                                                      Icons
                                                          .drive_file_rename_outline_rounded,
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                  controller: renameController,
                                                ),
                                                TextButton(
                                                  child: Text('Rename'),
                                                  onPressed: () {
                                                    changeFileNameOnly(file,
                                                        "${renameController.text}.aac");

                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                        setState(() {});
                                      },
                                      icon: const Icon(
                                        Icons.drive_file_rename_outline_sharp,
                                        size: 30,
                                      )),
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                                child: _isPlaying
                                    ? dBMeter(maxDB)
                                    : const SizedBox(
                                        height: 0,
                                      ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
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
        print(file);
        setState(() {
          records.remove(file);
          widget.records
              .removeAt(index); // Remove the deleted file from the list
        });
      }
    } catch (e) {
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

  String _getTimeFromFilePath({required String filePath}) {
    print("Path:${filePath}");
    String fromEpoch = filePath.substring(
        filePath.lastIndexOf('/') + 1, filePath.lastIndexOf('.'));

    DateTime recordedDate =
        DateTime.fromMillisecondsSinceEpoch(int.parse(fromEpoch));

    int hour = recordedDate.hour;
    int minute = recordedDate.minute;
    int second = recordedDate.second;

    return ('$hour:$minute:$second');
  }
}
