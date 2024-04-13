import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  final Widget child;

  const Tile({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: child,
      ),
    );
  }
}
