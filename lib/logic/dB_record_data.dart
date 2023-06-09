import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:noise_meter/noise_meter.dart';
import 'dB_meter.dart';

class dBRecordData extends StatefulWidget {
  const dBRecordData({super.key});

  @override
  dBRecordDataState createState() => dBRecordDataState();
}

class dBRecordDataState extends State<dBRecordData>
    with WidgetsBindingObserver {
  // five variables for noise recording
  bool isRecording = false;
  StreamSubscription<NoiseReading>? noiseSubscription;
  late NoiseMeter noiseMeter;
  double maxDB = 0;
  double? meanDB;

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
    return dBMeter(maxDB);
  }
}
