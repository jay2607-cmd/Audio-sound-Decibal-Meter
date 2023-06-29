import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jay_sound_meter/boxes/boxes.dart';
import 'package:jay_sound_meter/database/save_model.dart';
import 'package:jay_sound_meter/utils/constants.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../screens/save_main.dart';
import 'dB_Chart.dart';
import 'dB_meter.dart';

class NoiseApp extends StatefulWidget {
  const NoiseApp({super.key});

  @override
  NoiseAppState createState() => NoiseAppState();
}

class NoiseAppState extends State<NoiseApp> with WidgetsBindingObserver {
  DateTime currentDate = DateTime.now();
  DateTime currentTime = DateTime.now();

  // DBValueCount dbValueCount = DBValueCount();

  NoiseAppState() {
    selectedValue = areaTypeList[0];
  }

  // variables for dropdown list
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
  double maxDB = 0;
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
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed ||
        state == AppLifecycleState.paused) {
      chartData.clear();
    }
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

    chartData.add(
      ChartData(
        maxDB,
        meanDB,
        ((DateTime.now().millisecondsSinceEpoch - previousMillis) / 1000)
            .toDouble(),
      ),
    );
  }

  // error handle
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

  // User pressed stop
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
    String date = "${currentDate.day}-${currentDate.month}-${currentDate.year}";
    String time =
        "${currentTime.hour}:${currentTime.minute}:${currentTime.second}";

    bool _isDark = Theme.of(context).brightness == Brightness.dark;
    if (chartData.length >= 100) {
      chartData.removeAt(0);
    }
    return Container(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: IconButton(
              icon: Image.asset(
                'assets/images/back.png',
                height: 28,
                width: 28,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              "Noise Detector",
              style: kAppbarStyle,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: GestureDetector(
                  onDoubleTap: () {},
                  child: FloatingActionButton.extended(
                    heroTag: isRecording ? 'STOP' : 'START',
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    label: Text(
                      isRecording ? 'STOP' : 'START',
                      style: kButtonTextStyle,
                    ),
                    onPressed: isRecording ? stop : start,
                    backgroundColor:
                        isRecording ? Color(0xFFFF5959) : Color(0xFF1C95FF),
                  ),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: FloatingActionButton.extended(
                  label: const Text(
                    "SAVE",
                    style: kButtonTextStyle,
                  ),
                  heroTag: "SAVE",
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  backgroundColor: Color(0xFF33CC66),
                  onPressed: () {
                    final data = SaveModel(
                        noiseData: maxDB,
                        date: date,
                        time: time,
                        area: selectedValue.toString());

                    final box = Boxes.getData();

                    // forcefully added typecast
                    box.add(data);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SaveMain(
                              maxDB, date, time, selectedValue.toString())),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16, top: 6, bottom: 6),
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Color(0xFFF6F7F8)),
                  child: buildDropdownButtonFormField()),
            ),

            Container(height: 350, child: dBMeter(maxDB)),

            // depicts Mean dB
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text(
            //       meanDB != null
            //           ? 'Average: ${meanDB!.toStringAsFixed(2)} dB'
            //           : 'Awaiting data',
            //       style:
            //           const TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
            //     ),
            //   ],
            // ),

            // Chart according the noise meter
            Expanded(child: DBChart(chartData: chartData)),

            // space between chart and floatingActionButton
            const SizedBox(
              height: 68,
            ),
          ],
        ),
      ),
    );
  }

  Padding buildDropdownButtonFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          isExpanded: true,
          value: selectedValue,
          style: TextStyle(fontFamily: 'Montserrat', color: Colors.black),
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
                // selectedValue = newData;
              },
            );
          },
          icon: Image.asset(
            "assets/images/down.png",
            height: 25,
            width: 25,
          ),
        ),
        // dropdownColor: Color(0xFFF6F7F8),
        // decoration: InputDecoration(
        //     // labelText: "Choose Area",
        //     // border: UnderlineInputBorder(),
        //     ),
      ),
    );
  }
}

// class DBValueCount {
//   static double average = 0.0;
//   static double dbCount = 40.0;
//   static int increment = 0;
//   static double lastDbCount = 40.0;
//   static double maxDB = 0.0;
//   static double minDB = 100.0;
//   double volume = 10000.0;
//   late int i;
//
//   static get math => null;
//
//   static void setDbCount(double f) {
//     lastDbCount = dbCount;
//     dbCount = f;
//     int i = increment;
//     if (i > 0) {
//       average = ((average * (i - 1)) + f) / i.toDouble();
//       if (minDB > f) {
//         minDB = f;
//       }
//       if (maxDB < f) {
//         maxDB = f;
//       }
//     }
//     increment = i + 1;
//   }
//
//   double? maximum() {
//     double log10(num x) => log(x) / ln10;
//     if ((log10(volume) * 20.0) < 40.0) {
//       i = 15;
//     } else if ((log10(volume) * 20.0) < 50.0) {
//       i = 14;
//     } else {
//       i = (log10(volume) * 20.0) < 60.0 ? 10 : 9;
//     }
//     double? log1 = (log10(volume) * 20.0) - i;
//     // int i2 = log10.toInt();
//
//     DBValueCount.setDbCount(log1);
//     // df2.format()
//     return DBValueCount.maxDB;
//     //
//   }
// }
