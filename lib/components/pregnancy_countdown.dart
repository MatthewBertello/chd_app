import 'package:flutter/material.dart';
import 'package:chd_app/components/tile.dart';

class PregnancyCountdown extends StatelessWidget {
  final int currentDays;
  final int totalDays;
  final Widget? centerWidget;
  final double width;
  final double height;

  const PregnancyCountdown({
    super.key,
    required this.currentDays,
    required this.totalDays,
    this.centerWidget,
    this.width = 150,
    this.height = 150,
  });

  @override
  Widget build(BuildContext context) {
    return Tile(
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Contains the progress indicator and the text inside it
            CircularProgressIndicator(
              value: currentDays / totalDays,
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
      ),
    );
  }
}
