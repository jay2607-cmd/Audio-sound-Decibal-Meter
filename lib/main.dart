import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:jay_sound_meter/database/save_model.dart';
import 'package:jay_sound_meter/screens/camera.dart';
import 'package:jay_sound_meter/screens/home_screen.dart';
import 'package:jay_sound_meter/screens/settings.dart';
import 'package:path_provider/path_provider.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);

  Hive.registerAdapter(SaveModelAdapter());

  await Hive.openBox<SaveModel>("savedB");


  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

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
