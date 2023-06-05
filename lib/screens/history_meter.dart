import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HistoryMeter extends StatelessWidget {
  const HistoryMeter(
      {super.key,
      required this.maxDB,
      required this.date,
      required this.time,
      required this.area});

  final double maxDB;
  final String date, time, area;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("History"), centerTitle: true),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SfRadialGauge(
            title: const GaugeTitle(
                text: "dB Meter",
                textStyle:
                    TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
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
                      '${maxDB.toStringAsFixed(2)} dB',
                      style: const TextStyle(
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
          ),
          Column(
            children: [
              Text("Area : $area", style: const TextStyle(fontSize: 13)),
              Text("Date : $date", style: const TextStyle(fontSize: 13)),
              Text("Time : $time", style: const TextStyle(fontSize: 13)),
            ],
          )
        ],
      ),
    );
  }
}
