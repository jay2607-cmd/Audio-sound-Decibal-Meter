import 'package:hive/hive.dart';
import 'package:jay_sound_meter/database/save_model.dart';

class Boxes{
  static Box<SaveModel> getData() => Hive.box<SaveModel>("savedB");
}