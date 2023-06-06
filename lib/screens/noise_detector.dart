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
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: GestureDetector(
                //         onTap: () => setState(() {
                //           Navigator.pushNamed(context, '/settings');
                //         }),
                //         child: const Icon(
                //           Icons.settings,
                //           size: 28,
                //         ),
                //       ),
                //     )
                //   ],
                // ),

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
