import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../noise_detector.dart';

class ReusableGridView extends StatelessWidget {
  const ReusableGridView({
    super.key,
    required this.className,
    required this.label1,
    required this.label2,
    required this.imgPath,
  });

  final Widget className;
  final String? label1;
  final String? label2;
  final String imgPath;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => className));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFFF8F9F9),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(imgPath,height: 75, width: 75, fit: BoxFit.contain,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(label1!),
                    SizedBox(height: 10,),
                    Text(label2!,style: TextStyle(fontWeight: FontWeight.bold),),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
