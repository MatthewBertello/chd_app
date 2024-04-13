import 'package:flutter/material.dart';

class PregnancyCountdown extends StatelessWidget {
  final int currentDays;
  final int totalDays;
  final Widget? centerWidget;

  const PregnancyCountdown({
    super.key,
    required this.currentDays,
    required this.totalDays,
    this.centerWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        width: 150,
        height: 150,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Contains the progress indicator and the text inside it
            CircularProgressIndicator(
              value: currentDays / totalDays,
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${totalDays - currentDays} Days"),
                  Icon(Icons.pregnant_woman, color: Colors.pink[100], size: 50)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
