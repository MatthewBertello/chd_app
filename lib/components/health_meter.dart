import 'package:heart_safe/components/circular_meter.dart';
import 'package:heart_safe/components/tile.dart';
import 'package:flutter/material.dart';

class HealthMeter extends StatelessWidget {
  final double value;
  final EdgeInsetsGeometry? margin;

  const HealthMeter({
    super.key,
    required this.value,
    this.margin,
  });
///health meter is used to give the user an interactive visual of their health (physical, mental and social)
///the health meter is circled by the circular_meter
  @override
  Widget build(BuildContext context) {
    return Tile(
      margin: margin,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const Text("Health", textAlign: TextAlign.center),
          CircularMeter(
            value: value.toInt(),
            centerWidget: const Icon(
              Icons.favorite,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
