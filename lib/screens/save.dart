import 'package:flutter/material.dart';

class Save extends StatefulWidget {
  final double dBNoise;
  const Save({super.key, required this.dBNoise});

  @override
  State<Save> createState() => SaveState(dBNoise: dBNoise);
}

class SaveState extends State<Save> {
  final double? dBNoise;
  SaveState({required this.dBNoise});

  DateTime currentDate = DateTime.now();
  DateTime currentTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    String date = "${currentDate.day}-${currentDate.month}-${currentDate.year}";
    String time = "${currentTime.hour}:${currentTime.minute}:${currentTime.second}";

    print(dBNoise);
    return Scaffold(
      appBar: AppBar(
        title: Text("Saved Noise"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Text("${dBNoise?.toStringAsFixed(2)}"),
            Text(date),
            Text(time),
          ],
        ),
      ),
    );
  }
}
