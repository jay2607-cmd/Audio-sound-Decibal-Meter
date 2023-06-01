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
import 'package:syncfusion_flutter_gauges/gauges.dart';

class NoiseApp extends StatefulWidget {
  @override
  _NoiseAppState createState() => _NoiseAppState();
}

class _NoiseAppState extends State<NoiseApp> {
  _NoiseAppState() {
    _selectedValue = _areaTypeList[0];
  }

  // variable for dropdown list
  final _areaTypeList = ["Living Room", "Children's Room", "Study Room" , "Library" , "Kitchen" , "Bedroom" , "Bathroom" , "Toilet" ,"Stairs" , "Home office" , "Car" , "Office" , "HeadPhones"];

  String? _selectedValue;

  // five variables for noise recording
  bool _isRecording = false;
  StreamSubscription<NoiseReading>? _noiseSubscription;
  late NoiseMeter _noiseMeter;
  late double maxDB = 0;
  double? meanDB;

  // These three variables for chart
  List<_ChartData> chartData = <_ChartData>[];
  ChartSeriesController? _chartSeriesController;
  late int previousMillis;

  @override
  void initState() {
    super.initState();
    _noiseMeter = NoiseMeter(onError);
  }

  void onData(NoiseReading noiseReading) {
    setState(() {
      if (!_isRecording) _isRecording = true;
    });
    maxDB = noiseReading.maxDecibel;
    meanDB = noiseReading.meanDecibel;

    chartData.add(
      _ChartData(
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
    _isRecording = false;
  }

  void start() async {
    previousMillis = DateTime.now().millisecondsSinceEpoch;
    try {
      _noiseSubscription = _noiseMeter.noiseStream.listen(onData);
    } catch (e) {
      print(e);
    }
  }

  void stop() async {
    try {
      _noiseSubscription!.cancel();
      _noiseSubscription = null;

      setState(() => _isRecording = false);
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
        label: Text(_isRecording ? 'Stop' : 'Start'),
        onPressed: _isRecording ? stop : start,
        icon: !_isRecording
            ? const Icon(Icons.not_started_sharp)
            : const Icon(Icons.stop_circle_sharp),
        backgroundColor: _isRecording ? Colors.red : Colors.green,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // DropdownButton(
          //   value: _selectedValue,
          //     items: _areaTypeList
          //         .map((e) => DropdownMenuItem(
          //               child: Text(e),
          //               value: e,
          //             ))
          //         .toList(),
          //     onChanged: (val) {
          //     setState(() {
          //       _selectedValue = val as String;
          //     },);
          //     },),

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: DropdownButtonFormField(
              value: _selectedValue,
              items: _areaTypeList
                  .map((e) => DropdownMenuItem(
                        child: Text(e),
                        value: e,
                      ))
                  .toList(),
              onChanged: (val) {
                setState(
                  () {
                    _selectedValue = val as String;
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
              child: SfRadialGauge(
            title: const GaugeTitle(text: "dB Meter"),
            enableLoadingAnimation: true,
            axes: [
              RadialAxis(
                minimum: 0,
                maximum: 150,
                pointers: [
                  NeedlePointer(
                    value: maxDB,
                    enableAnimation: true,
                  )
                ],
                ranges: [
                  GaugeRange(startValue: 0, endValue: 50, color: Colors.green),
                  GaugeRange(
                      startValue: 50, endValue: 100, color: Colors.orange),
                  GaugeRange(startValue: 100, endValue: 160, color: Colors.red),
                ],
                annotations: [
                  GaugeAnnotation(
                    widget: Text(
                      '${maxDB.floorToDouble()} dB',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    positionFactor: 0.5,
                    angle: 90,
                  )
                ],
              ),
            ],
          )),

          // depicts Mean dB
          Text(
            meanDB != null
                ? 'Average: ${meanDB!.toStringAsFixed(2)} dB'
                : 'Awaiting data',
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
          ),

          // Chart according the noise meter
          Expanded(
            child: SfCartesianChart(
              title: ChartTitle(text: 'dB Graph'),
              // tooltipBehavior: TooltipBehavior(enable: true),
              series: <LineSeries<_ChartData, double>>[
                LineSeries<_ChartData, double>(
                    dataLabelSettings: const DataLabelSettings(
                      isVisible: true,
                    ),
                    dataSource: chartData,
                    xAxisName: 'Time',
                    yAxisName: 'dB',
                    name: 'dB values over time',
                    xValueMapper: (_ChartData value, _) => value.frames,
                    yValueMapper: (_ChartData value, _) => value.maxDB?.floor(),
                    animationDuration: 1),
              ],
            ),
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

class _ChartData {
  final double? maxDB;
  final double? meanDB;
  final double frames;

  _ChartData(this.maxDB, this.meanDB, this.frames);
}

