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
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class NoiseApp extends StatefulWidget {
  @override
  _NoiseAppState createState() => _NoiseAppState();
}

class _NoiseAppState extends State<NoiseApp> {
  bool _isRecording = false;
// ignore: cancel_subscriptions
  StreamSubscription<NoiseReading>? _noiseSubscription;
  late NoiseMeter _noiseMeter;
  late double maxDB = 0;
  double? meanDB;
  List<_ChartData> chartData = <_ChartData>[];
  ChartSeriesController? _chartSeriesController;
  late int previousMillis;

  @override
  void initState() {
    super.initState();

    _noiseMeter = NoiseMeter(onError);
  }

  void onData(NoiseReading noiseReading) {
    this.setState(() {
      if (!this._isRecording) this._isRecording = true;
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
    print(e.toString());
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

      this.setState(() => this._isRecording = false);
    } catch (e) {
      print('stopRecorder error: $e');
    }
    previousMillis = 0;
    chartData.clear();
  }

  // void copyValue(
  //   bool theme,
  // ) {
  //   Clipboard.setData(
  //     ClipboardData(
  //         text: 'It\'s about ${maxDB!.toStringAsFixed(1)}dB loudness'),
  //   ).then((_) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         behavior: SnackBarBehavior.floating,
  //         duration: Duration(milliseconds: 2500),
  //         content: Row(
  //           children: [
  //             Icon(
  //               Icons.check,
  //               size: 14,
  //               color: theme ? Colors.white70 : Colors.black,
  //             ),
  //             SizedBox(width: 10),
  //             Text('Copied')
  //           ],
  //         ),
  //       ),
  //     );
  //   });
  // }

  // openGithub() async {
  //   const url = 'https://github.com/iqfareez/noise_meter_flutter';
  //   try {} catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text('Could not launch $url'),
  //       backgroundColor: Colors.red,
  //     ));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    bool _isDark = Theme.of(context).brightness == Brightness.dark;
    if (chartData.length >= 25) {
      chartData.removeAt(0);
    }
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        label: Text(_isRecording ? 'Stop' : 'Start'),
        onPressed: _isRecording ? stop : start,
        icon: !_isRecording ? Icon(Icons.circle) : null,
        backgroundColor: _isRecording ? Colors.red : Colors.green,
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: SfRadialGauge(
            title: GaugeTitle(text: "dB Meter"),
            enableLoadingAnimation: true,
            axes: [
              RadialAxis(
                minimum: 0,
                maximum: 160,
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
          // Expanded(
          //   child: Text(
          //     maxDB != null ? maxDB!.toStringAsFixed(2) : 'Press start',
          //     style: const TextStyle(fontSize: 25),
          //   ),
          // ),

          Text(
            meanDB != null
                ? 'Mean: ${meanDB!.toStringAsFixed(2)}'
                : 'Awaiting data',
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
          ),
          Expanded(
            child: SfCartesianChart(
              title: ChartTitle(text: 'dB Graph'),
              series: <LineSeries<_ChartData, double>>[
                LineSeries<_ChartData, double>(
                    dataLabelSettings: DataLabelSettings(isVisible: false),
                    dataSource: chartData,
                    xAxisName: 'Time',
                    yAxisName: 'dB',
                    name: 'dB values over time',
                    xValueMapper: (_ChartData value, _) => value.frames,
                    yValueMapper: (_ChartData value, _) => value.maxDB,
                    animationDuration: 1),
              ],

            ),
          ),

          SizedBox(
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
