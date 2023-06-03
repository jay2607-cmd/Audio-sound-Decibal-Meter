import 'package:hive/hive.dart';
part 'save_model.g.dart';

@HiveType(typeId: 0)
class SaveModel extends HiveObject{
  
  @HiveField(0)
  late double noiseData;

  @HiveField(1)
  late String date;

  @HiveField(2)
  late String area;

  @HiveField(3)
  late String time;

  SaveModel({required this.noiseData, required this.date, required this.area, required this.time,});

}