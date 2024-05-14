import 'package:flutter/material.dart';
import 'package:chd_app/components/tile.dart';
///Author: 
///Date: 5/14/24
///Description: This is the file that allows the meter to change based on the rolling data entered
///Bugs: None Known


class PregnancyCountdown extends StatelessWidget {
  final int currentDays;
  final int totalDays;
  final Widget? centerWidget;
  final EdgeInsetsGeometry? margin;

  const PregnancyCountdown({  
    ///this shows a countdown based on the curent date and the users entered due date
    super.key,
    required this.currentDays, 
    required this.totalDays, 
    this.centerWidget,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Tile(
      margin: margin,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Contains the progress indicator and the text inside it
          CircularProgressIndicator(
            value: (totalDays == 0) ? 0 : currentDays / totalDays,
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
            backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(.5),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${totalDays - currentDays} Days"),
                Icon(Icons.pregnant_woman, color: Theme.of(context).colorScheme.tertiary, size: 50)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
