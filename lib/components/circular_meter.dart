import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

///circular meter is used to give user a visual of how their health is. 'health' is calculated by rolling
///data that is self entered. these values are then averaged based on catagory and the dial changes  
///apperance based off the range of the values
class CircularMeter extends StatelessWidget {
  late final int value;
  final Map<int, Color> colorMap;
  final Widget? centerWidget;

  CircularMeter({
    super.key,
    required value, 
    this.colorMap = const {
      0: Colors.red,  ///values are in the 'poor' range
      50: Colors.yellow, ///values are in the 'average' range
      75: Colors.lightGreen, ///values are in the 'good' range
      100: Colors.green ///values are in the 'excellent' range
    },
    this.centerWidget,
  }) {
    this.value = value.clamp(0, 100);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.expand, children: [
      SfCircularChart(
        series: <CircularSeries>[
          DoughnutSeries<String, Object>(
            dataSource: const ['Full', 'Empty'],
            xValueMapper: (datum, _) => datum,
            yValueMapper: (datum, _) => datum == 'Full' ? value : 100 - value,
            pointColorMapper: (datum, _) {
              switch (datum) {
                case 'Full':
                  return getColor(value);
                case 'Empty':
                  return Colors.transparent;
              }
              return null;
            },
          ),
        ],
      ),
      centerWidget == null ? Container() : Center(child: centerWidget),
    ]);
  }

  Color getColor(int value) {
    // sort the keys in the colorMap
    List<int> keys = colorMap.keys.toList()..sort();

    // find the two keys that the value is between
    int lowerKey = keys.firstWhere((element) => element <= value,
        orElse: () => keys.first);
    int upperKey =
        keys.firstWhere((element) => element >= value, orElse: () => keys.last);

    // find the colors for the two keys
    Color lowerColor = colorMap[lowerKey]!;
    Color upperColor = colorMap[upperKey]!;

    // calculate the ratio between the two keys
    // add 0.1 to avoid division by zero
    double ratio = (value - lowerKey) / ((upperKey - lowerKey) + 0.1);

    // blend the two colors
    return Color.lerp(lowerColor, upperColor, ratio)!;
  }
}
