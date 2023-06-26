import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jay_sound_meter/logic/dB_meter.dart';

import '../../utils/constants.dart';

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
        title: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            "History Meter ",
            style: kAppbarStyle,
          ),
        ),
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          dBMeter(maxDB),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Noise Detected :",
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      " ${maxDB.toStringAsFixed(2)} dB",
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1C95FF)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 4,
                ),
                Text("Area : $area", style: const TextStyle(fontSize: 13)),
                SizedBox(
                  height: 4,
                ),
                Text("Date : $date", style: const TextStyle(fontSize: 13)),
                SizedBox(
                  height: 4,
                ),
                Text("Time : $time", style: const TextStyle(fontSize: 13)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
