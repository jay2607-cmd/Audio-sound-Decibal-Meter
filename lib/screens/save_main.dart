import 'package:flutter/material.dart';
import 'package:jay_sound_meter/boxes/boxes.dart';
import 'package:jay_sound_meter/database/save_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jay_sound_meter/screens/views/history_meter.dart';

class SaveMain extends StatefulWidget {

  double? dBNoise;
  String? date, time, area;

  SaveMain(double this.dBNoise, String this.date, this.time, this.area);

  SaveMain.history({super.key});

  @override
  State<SaveMain> createState() =>
      SaveMainState(dBNoise: dBNoise, date: date, time: time, area: area);
}

class SaveMainState extends State<SaveMain> {
  final double? dBNoise;
  final String? date, time, area;
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
              int reversedIndex = data.length - 1 - index;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HistoryMeter(
                        maxDB: data[reversedIndex].noiseData,
                        area: data[reversedIndex].area.toString(),
                        date: data[reversedIndex].date.toString(),
                        time: data[reversedIndex].time.toString(),
                      ),
                    ),
                  );
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Noise : ${data[reversedIndex].noiseData.toStringAsFixed(2)} dB",
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
                                delete(data[reversedIndex]);
                              },
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                          ],
                        ),
                        Text("Area : ${data[reversedIndex].area.toString()}",
                            style: const TextStyle(fontSize: 13)),
                        Text("Date : ${data[reversedIndex].date.toString()}",
                            style: const TextStyle(fontSize: 13)),
                        Text("Time : ${data[reversedIndex].time.toString()}",
                            style: const TextStyle(fontSize: 13)),
                      ],
                    ),
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
