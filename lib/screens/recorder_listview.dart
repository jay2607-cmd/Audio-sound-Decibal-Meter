// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  _RecordListViewState createState() => _RecordListViewState();
}

class _RecordListViewState extends State<RecordListView>
    with WidgetsBindingObserver {
  _RecordListViewState();

  AudioPlayer audioPlayer = AudioPlayer();

  TextEditingController renameController = TextEditingController();

  bool isRenamePressed = false;

  // variables for noise recording
  bool isRecording = false;
  StreamSubscription<NoiseReading>? noiseSubscription;
  late NoiseMeter noiseMeter;
  double maxDB = 0;
  double? meanDB;

  // late final Directory appDirectory;

  // List<String> widget.records;
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
    noiseStop();
  }

  //method for taking noise data
  void onData(NoiseReading noiseReading) {
    // setState(() {
    //   if (!isRecording) isRecording = true;
    // });
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

  void noiseStart() async {
    try {
      noiseSubscription = noiseMeter.noiseStream.listen(onData);
    } catch (e) {
      print(e);
    }
  }

  void noiseStop() async {
    try {
      noiseSubscription!.cancel();
      noiseSubscription = null;

      // setState(() => isRecording = false);
    } catch (e) {
      if (kDebugMode) {
        print('stopRecorder error: $e');
      }
    }
  }

  FutureBuilder<DateTime> dateAndTime(int i) {
    return FutureBuilder<DateTime>(
      future: getFileLastModified(widget.records.elementAt(i)),
      builder: (BuildContext context, AsyncSnapshot<DateTime> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          DateTime lastModified = snapshot.data!;

          String time = DateFormat.jm().format(lastModified); // Format the time
          String date =
              DateFormat.yMMMd().format(lastModified); // Format the date

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Date: $date', style: TextStyle(fontSize: 16)),

              // SizedBox(height: 16),
              Text('Time: $time', style: TextStyle(fontSize: 16)),
              // Text(time, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          );
        } else {
          return Text('File does not exist.');
        }
      },
    );
  }

  IconButton renameIcon(BuildContext context, File file, int position) {
    return IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title:
                    const Text('Rename!', style: TextStyle(color: Colors.blue)),
                content: const Text('Do you really want to rename this file!'),
                actions: [
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(10)),
                      hintText: 'Enter New Name',
                      helperText: 'Keep it meaningful',
                      labelText: 'Rename',
                      prefixIcon: const Icon(
                        Icons.drive_file_rename_outline_rounded,
                        color: Colors.blue,
                      ),
                    ),
                    controller: renameController,
                  ),
                  TextButton(
                    child: Text('Rename'),
                    onPressed: () async {
                      Navigator.pop(context);

                      await changeFileNameOnly(
                          file, "${renameController.text}.aac");
                      // records.clear();
                      var path = file.path;
                      var lastSeparator =
                          path.lastIndexOf(Platform.pathSeparator);
                      var newPath =
                          "${path.substring(0, lastSeparator + 1)}${renameController.text}.aac";
                      widget.records[position] = newPath;
                      print(
                          "List Path ${widget.records.elementAt(position)}\nNewPath $newPath");

                      setState(() {});
                      /*getApplicationDocumentsDirectory().then((value) {
                        appDirectory = value;
                        appDirectory.list().listen((onData) {
                          if (onData.path.contains('.aac')) records.add(onData.path);
                        }).onDone(() {
                          records = records.reversed.toList();
                          setState(() {});
                        });
                      });*/
                    },
                  ),
                ],
              );
            },
          );
        },
        icon: const Icon(
          Icons.drive_file_rename_outline_sharp,
          size: 30,
        ));
  }

  FloatingActionButton noiseMeasureFloatingIcon() {
    // print("isRecording: ${isRecording}");
    return FloatingActionButton.extended(
      shape: const CircleBorder(),
      elevation: 0,
      backgroundColor: Colors.blue.shade50,
      foregroundColor: Colors.blue.shade500,
      label: const Text(''),
      // onPressed: isRecording ? noiseStop : noiseStart,
      onPressed: () {
        if (isRecording) {
          isRecording = false;

          noiseStop();
        } else {
          isRecording = true;
          noiseStart();
        }
      },

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
    );
  }

  IconButton deleteIcon(BuildContext context, int i) {
    return IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title:
                    const Text('Warning!', style: TextStyle(color: Colors.red)),
                content: const Text('Do you really want to delete this file!'),
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
                      deleteFile(File(widget.records.elementAt(i)), i);
                      // deleteAllFilesInFolder();
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
        ));
  }

  IconButton resetIcon() {
    return IconButton(
        onPressed: () {
          _onStop();
        },
        icon: const Icon(
          Icons.stop_circle_rounded,
          size: 30,
          color: Colors.red,
        ));
  }

  IconButton playPauseIcon(int i) {
    return IconButton(
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
          _onPlay(filePath: widget.records.elementAt(i), index: i);
        }
      },
    );
  }

  Future<void> deleteFile(File file, int index) async {
    try {
      if (await file.exists()) {
        await file.delete();
        print(file);
        setState(() {
          widget.records.remove(file);
          widget.records
              .removeAt(index); // Remove the deleted file from the list
        });
      }
    } catch (e) {
      print(e);
    }
    setState(() {});
  }

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
          isRecording = false;
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
      isRecording = false;
      noiseStop();
      _completedPercentage = 0.0;
    });
    noiseStop;
  }

  Future<void> _onPause() async {
    audioPlayer.pause();
    setState(() {
      _isPlaying = false;
      isRecording = false;
      noiseStop();
    });
  }

  Future<File> replaceFile(File file, String newFileName) async {
    var path = file.path;

    var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
    var newPath = path.substring(0, lastSeparator + 1) + newFileName;
    print("new path: ${newPath}");
    return await file.rename(newPath);
  }

  Future<File?> changeFileNameOnly(File file, String newFileName) async {
    var path = file.path;
    var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
    var newPath = path.substring(0, lastSeparator + 1) + newFileName;

    // Check if the new file name already exists
    var newFile = File(newPath);
    if (await newFile.exists()) {
      // Show an alert dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('File Name Already Exists'),
            content: const Text('The specified file name already exists.'),
            actions: [
              // Cancel button
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(null);
                },
              ),
              // Replace button
              TextButton(
                child: const Text('Replace'),
                onPressed: () {
                  replaceFile(file, "${renameController.text}.aac");
                  Navigator.of(context).pop(file);
                  setState(() {});
                },
              ),
            ],
          );
        },
      );
      return null; // Return null to indicate failure
    }

    // Rename the file
    await file.rename(newPath);
    return newFile;
  }

  Future<DateTime> getFileLastModified(String filepath) async {
    File file = File(filepath);

    if (await file.exists()) {
      DateTime lastModified = await file.lastModified();
      return lastModified;
    } else {
      throw Exception('File does not exist.');
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
                          dateAndTime(i),
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
                                  playPauseIcon(i),
                                  resetIcon(),
                                  deleteIcon(context, i),
                                  GestureDetector(
                                    onDoubleTap: () {},
                                    child: noiseMeasureFloatingIcon(),
                                  ),
                                  renameIcon(context, file, i),
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: [
                                    if (_isPlaying)
                                      dBMeter(maxDB)
                                    else
                                      const SizedBox(
                                        height: 0,
                                      ),
                                  ],
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
}
