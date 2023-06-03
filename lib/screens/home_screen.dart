import 'package:flutter/material.dart';
import '../logic/dB_Data.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () => setState(() {
                          Navigator.pushNamed(context, '/settings');
                        }),
                        child: const Icon(
                          Icons.settings,
                          size: 28,
                        ),
                      ),
                    )
                  ],
                ),

                // Center(
                //   child: Expanded(

                //     child: Radial(),
                //   ),
                // ),

                Expanded(
                  child: NoiseApp(),
                ),


                // Expanded(child: )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
