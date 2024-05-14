import 'package:flutter/material.dart';
///Author:
///Date: 5/14/24
///Description: This is the file that allows the meter to change based on the rolling data entered
///Bugs: None Known
class Tile extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const Tile({
    super.key,
    required this.child,
    this.margin,
    this.padding = const EdgeInsets.all(10),
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: margin,
      child: Container(
        padding: padding,
        child: child,
      ),
    );
  }
}
