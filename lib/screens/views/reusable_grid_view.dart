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
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xFFF8F9F9),
        ),
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          top: 10,
          bottom: 10,
        ),
        child: Stack(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Image.asset(
                    imgPath,
                    height: 70,
                    width: 70,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
            SizedBox.shrink(),
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // alignment: Alignment.center,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(label1!),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        label2!,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
