import 'package:chd_app/components/circular_meter.dart';
import 'package:flutter/material.dart';

class HealthMeter extends StatelessWidget {
  final double value;

  const HealthMeter({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 150,
      child: Stack(fit: StackFit.expand, children: [
        const Text("Health", textAlign: TextAlign.center),
        CircularMeter(
          value: value,
          centerWidget: const Icon(
            Icons.favorite,
            color: Colors.red,
          ),
        ),
      ]),
    );
  }
}
