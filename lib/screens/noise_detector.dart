import 'package:flutter/material.dart';
import '../logic/dB_Data.dart';

class NoiseDetector extends StatefulWidget {
  const NoiseDetector({super.key});

  @override
  State<StatefulWidget> createState() => _NoiseDetectorState();
}

class _NoiseDetectorState extends State<NoiseDetector> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: const SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: NoiseApp(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
