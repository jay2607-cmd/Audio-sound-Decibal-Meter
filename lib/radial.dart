import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jay_sound_meter/data_and_chart.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class Radial extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StateRadial();
}

class _StateRadial extends State<Radial> {
  @override
  Widget build(BuildContext context) {
  NoiseApp noiseApp = NoiseApp();
    return SfRadialGauge(
      title: GaugeTitle(text: "dB Meter"),
      enableLoadingAnimation: true,
      axes: [
        RadialAxis(
          minimum: 0,
          maximum: 160,
          pointers: [
            NeedlePointer(
              value: 56,
              enableAnimation: true,
            )
          ],
          ranges: [
            GaugeRange(startValue: 0, endValue: 50, color: Colors.green),
            GaugeRange(startValue: 50, endValue: 100, color: Colors.orange),
            GaugeRange(startValue: 100, endValue: 160, color: Colors.red),
          ],
          annotations: [
            GaugeAnnotation(
              widget: Text(
                '90 MPH',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              positionFactor: 0.5,
              angle: 90,
            )
          ],
        ),
      ],
    );
  }
}

