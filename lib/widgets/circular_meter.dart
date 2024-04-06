import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CircularMeter extends StatelessWidget {
  final double value;
  final Map<double, Color> colorMap;
  final Widget? centerWidget;

  CircularMeter({
    required this.value,
    required this.colorMap,
    this.centerWidget,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(fit: StackFit.expand, children: [
      SfCircularChart(
        series: <CircularSeries>[
          DoughnutSeries<String, Object>(
            dataSource: const ['Full', 'Empty'],
            xValueMapper: (datum, _) => datum,
            yValueMapper: (datum, _) => datum == 'Full' ? value : 1 - value,
            pointColorMapper: (datum, _) {
              switch (datum) {
                case 'Full':
                  return getColor(value);
                case 'Empty':
                  return Colors
                      .transparent;
              }
              return null;
            },
          ),
        ],
      ),
      centerWidget == null ? Container() : Center(child: centerWidget),
    ]));
  }

  Color getColor(double value) {   
    // sort the keys in the colorMap
    List<double> keys = colorMap.keys.toList()..sort();

    // find the two keys that the value is between
    double lowerKey = keys.firstWhere((element) => element <= value, orElse: () => keys.first);
    double upperKey = keys.firstWhere((element) => element >= value, orElse: () => keys.last);

    // find the colors for the two keys
    Color lowerColor = colorMap[lowerKey]!;
    Color upperColor = colorMap[upperKey]!;

    // calculate the ratio between the two keys
    double ratio = (value - lowerKey) / (upperKey - lowerKey);

    // blend the two colors
    return Color.lerp(lowerColor, upperColor, ratio)!;
  }
}
