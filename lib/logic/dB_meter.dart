import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class dBMeter extends StatefulWidget {
  double maxDB = 12;

  dBMeter(
    double this.maxDB,
  );

  dBMeter.doNothing({super.key});

  @override
  State<dBMeter> createState() => _dBMeterState();
}

class _dBMeterState extends State<dBMeter> {
  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      title: const GaugeTitle(text: "dB Meter"),
      // enableLoadingAnimation: true,
      axes: [
        RadialAxis(
          minimum: 0,
          maximum: 150,
          pointers: [
            NeedlePointer(
              value: widget.maxDB,
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
                '${widget.maxDB.toStringAsFixed(2)} dB',
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
