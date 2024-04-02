import 'package:chd_app/launch.dart';
import 'package:chd_app/settings.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

// hello
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Settings()
        ),
      ),
    );
  }
}
//hi from line 21
// hi from Matthew Steffens