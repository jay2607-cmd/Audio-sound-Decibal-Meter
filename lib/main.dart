import 'package:flutter/material.dart';
import 'package:jay_sound_meter/settings.dart';
import 'package:jay_sound_meter/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      title: "Jay's dB Meter",
      routes: {
        '/': (context) => HomeScreen(),
        '/settings': (context) => const Settings(),
      },
    );
  }
}
