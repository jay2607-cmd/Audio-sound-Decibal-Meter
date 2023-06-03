import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:jay_sound_meter/boxes/boxes.dart';
import 'package:jay_sound_meter/database/save_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SaveMain extends StatefulWidget {
  final double noiseData;
  final String date, time, area;
  const SaveMain(
      {super.key,
      required this.noiseData,
      required this.date,
      required this.time,
      required this.area});

  @override
  State<SaveMain> createState() =>
      SaveMainState(dBNoise: noiseData, date: date, time: time, area: area);
}

class SaveMainState extends State<SaveMain> {
  final double dBNoise;
  final String date, time, area;
  SaveMainState(
      {required this.dBNoise,
      required this.date,
      required this.time,
      required this.area});

  @override
  Widget build(BuildContext context) {
    print(dBNoise);
    return Scaffold(
      appBar: AppBar(
        title: Text("Saved Noise"),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<Box<SaveModel>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (context, box, _) {
          var data = box.values.toList().cast<SaveModel>();

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              return Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            data[index].noiseData.toStringAsFixed(2),
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          const Spacer(),
                          InkWell(
                            child: const Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                            onTap: () {
                              delete(data[index]);
                            },
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                        ],
                      ),
                      Text(data[index].date.toString(),
                          style: const TextStyle(fontSize: 13)),
                      Text(data[index].area.toString(),
                          style: const TextStyle(fontSize: 13)),
                      Text(data[index].time.toString(),
                          style: const TextStyle(fontSize: 13)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void delete(SaveModel saveModel) async {
    await saveModel.delete();
  }
}
