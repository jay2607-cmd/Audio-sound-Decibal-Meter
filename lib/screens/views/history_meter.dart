import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jay_sound_meter/logic/dB_meter.dart';

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
          dBMeter(maxDB),
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
