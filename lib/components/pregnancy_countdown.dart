import 'package:flutter/material.dart';
import 'package:heart_safe/components/tile.dart';
///Author: Pachia lee
///Date: 5/14/24
///Description: changes the color of the circle meter depending on how close you are to the due date
///the circle is more green depending on how closer you are to your due date
///Bugs: None Known
///reflection:


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
