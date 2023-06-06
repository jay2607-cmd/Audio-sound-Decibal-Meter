import 'package:flutter/material.dart';

import 'noise_detector.dart';

class ReusableGridView extends StatelessWidget {
  const ReusableGridView({
    super.key,
    required this.className,
    required this.icon,
    required this.label,
    required this.getColor,
  });

  final Widget className;
  final IconData icon;
  final String? label;
  final Color getColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => className));
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        color: getColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.black,
              size: 70,
            ),
            SizedBox(
              height: 15,
            ),
            Text(label!),
          ],
        ),
      ),
    );
  }
}
