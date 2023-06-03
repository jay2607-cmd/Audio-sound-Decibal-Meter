import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class dBMeter extends StatelessWidget {
  const dBMeter({
    super.key,
    required this.maxDB,
  });

  final double maxDB;


  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
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
    );
  }
}
