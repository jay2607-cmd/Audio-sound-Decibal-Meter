import 'package:flutter/material.dart';
import 'package:jay_sound_meter/screens/history_meter.dart';
import 'package:jay_sound_meter/screens/save_main.dart';
import 'package:jay_sound_meter/screens/settings.dart';
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
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'Noise Meter',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                title: Text('Saved Noise'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>   SaveMain.history()));
                },
              ),
              ListTile(
                title: Text('Settings'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>  const Settings()));
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text("Noise meter"),
          centerTitle: true,
        ),
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

                // Expanded(child: )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
