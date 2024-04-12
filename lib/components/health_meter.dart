import 'package:chd_app/components/circular_meter.dart';
import 'package:flutter/material.dart';

class HealthMeter extends StatelessWidget {
  final int value;

  const HealthMeter({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Widget displaying the health meter
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: const BorderRadius.all(Radius.circular(30))),
      child: SizedBox(
        width: 150,
        height: 150,
        child: Stack(fit: StackFit.expand, children: [
          Text("Health",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.indigo[900], fontWeight: FontWeight.bold)),
          CircularMeter(
            value: value,
            centerWidget: const Icon(
              Icons.favorite,
              color: Colors.red,
            ),
          ),
        ]),
      ),
    );
  }
}
