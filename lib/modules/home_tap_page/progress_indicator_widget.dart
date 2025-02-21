import 'package:flutter/material.dart';
import 'package:vo_ninja/shared/style/color.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final String? label;
  final double? percentage;

  const ProgressIndicatorWidget({
    super.key,
    required this.label,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label![0].toUpperCase() + label!.substring(1).toLowerCase(),
          style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 80,
              width: 80,
              child: CircularProgressIndicator(
                value: percentage,
                strokeWidth: 18,
                backgroundColor: const Color(0xFF979A9A),
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.secondColor),
              ),
            ),
            Text(
              '${(percentage! * 100).toInt()}%',
              style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
