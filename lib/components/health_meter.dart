import 'package:chd_app/components/circular_meter.dart';
import 'package:chd_app/components/tile.dart';
import 'package:flutter/material.dart';

class HealthMeter extends StatelessWidget {
  final double value;
  final EdgeInsetsGeometry? margin;

  const HealthMeter({
    super.key,
    required this.value,
    this.margin,
  });

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
