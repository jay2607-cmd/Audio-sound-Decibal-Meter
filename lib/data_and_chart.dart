// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';
//
// class Data extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _DataState();
// }
//
// class _DataState extends State<Data> {
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Text("demo.randomData().toString()");
//   }
// }
//
//

// https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/chart/dynamic_updates/live_update/real_time_line_chart.dart

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dB_meter.dart';

class NoiseApp extends StatefulWidget {
  const NoiseApp({super.key});

  @override
  NoiseAppState createState() => NoiseAppState();
}

class NoiseAppState extends State<NoiseApp> {
  NoiseAppState() {
    selectedValue = areaTypeList[0];
  }

  // variable for dropdown list
  final areaTypeList = [
    "Living Room (35- 50 dB)",
    "Children's Room (35- 40 dB)",
    "Study Room (35- 35 dB)",
    "Library (35- 40 dB)",
    "Kitchen (40- 45 dB)",
    "Bedroom (20- 25 dB)",
    "Bathroom (42- 47 dB)",
    "Toilet (35- 50 dB)",
    "Stairs (35- 50 dB)",
    "Home office (35- 50 dB)",
    "Car (50- 70 dB)",
    "Office (45- 60 dB)",
    "HeadPhones (60- 85 dB)"
  ];

  String? selectedValue;

  // five variables for noise recording
  bool isRecording = false;
  StreamSubscription<NoiseReading>? noiseSubscription;
  late NoiseMeter noiseMeter;
  late double maxDB = 0;
  double? meanDB;

  // These three variables for chart
  List<ChartData> chartData = <ChartData>[];
  ChartSeriesController? _chartSeriesController;
  late int previousMillis;

  @override
  void initState() {
    super.initState();
    noiseMeter = NoiseMeter(onError);
    start();
  }

  void onData(NoiseReading noiseReading) {
    setState(() {
      if (!isRecording) isRecording = true;
    });
    maxDB = noiseReading.maxDecibel;
    meanDB = noiseReading.meanDecibel;

    chartData.add(
      ChartData(
        maxDB,
        meanDB,
        ((DateTime.now().millisecondsSinceEpoch - previousMillis) / 1000)
            .toDouble(),
      ),
    );
  }

  void onError(Object e) {
    if (kDebugMode) {
      print(e.toString());
    }
    isRecording = false;
  }

  void start() async {
    previousMillis = DateTime.now().millisecondsSinceEpoch;
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
    previousMillis = 0;
    chartData.clear();
  }

  @override
  Widget build(BuildContext context) {
    bool _isDark = Theme.of(context).brightness == Brightness.dark;
    if (chartData.length >= 10) {
      chartData.removeAt(0);
    }
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        label: Text(isRecording ? 'Stop' : 'Start'),
        onPressed: isRecording ? stop : start,
        icon: !isRecording
            ? const Icon(Icons.not_started_sharp)
            : const Icon(Icons.stop_circle_sharp),
        backgroundColor: isRecording ? Colors.red : Colors.green,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: DropdownButtonFormField(
              value: selectedValue,
              items: areaTypeList
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: (val) {
                setState(
                  () {
                    selectedValue = val as String;
                  },
                );
              },
              icon: Icon(Icons.arrow_drop_down_circle,
                  color: Colors.purple.shade400),
              dropdownColor: Colors.deepPurple.shade50,
              decoration: InputDecoration(
                labelText: "Choose Area",
                prefixIcon: Icon(
                  Icons.accessibility_new_rounded,
                  color: Colors.purple.shade500,
                ),
                border: UnderlineInputBorder(),
              ),
            ),
          ),

          Expanded(
              // Radial Gauge
              child: dBMeter(maxDB: maxDB)),

          // depicts Mean dB
          Text(
            meanDB != null
                ? 'Average: ${meanDB!.toStringAsFixed(2)} dB'
                : 'Awaiting data',
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
          ),

          // Chart according the noise meter
          Expanded(
            child: RadialGauge(chartData: chartData),
          ),

          // space between chart and floatingActionButton
          const SizedBox(
            height: 68,
          ),
        ],
      ),
    );
  }
}

class RadialGauge extends StatelessWidget {
  const RadialGauge({
    super.key,
    required this.chartData,
  });

  final List<ChartData> chartData;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: ChartTitle(text: 'dB Graph'),
      series: <LineSeries<ChartData, double>>[
        LineSeries<ChartData, double>(
            dataLabelSettings: const DataLabelSettings(
              // isVisible: true,
            ),
            dataSource: chartData,
            xAxisName: 'Time',
            yAxisName: 'dB',
            name: 'dB values over time',
            xValueMapper: (ChartData value, _) => value.frames,
            yValueMapper: (ChartData value, _) => value.maxDB?.floor(),
            animationDuration: 1
       ),
      ],
    );
  }
}


class ChartData {
  final double? maxDB;
  final double? meanDB;
  final double frames;

  ChartData(this.maxDB, this.meanDB, this.frames);
}
