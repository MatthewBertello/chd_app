import 'package:flutter/material.dart';
import 'test_model.dart';

// View screen from overview tab
class Settings extends StatelessWidget {
  const Settings({super.key, required this.model});
  final TestModel model;

  // Builds the app bar
  // TODO: Make text white
  AppBar buildAppBar(BuildContext context) {
    return AppBar(
        title: const Text("Settings"),
        flexibleSpace: Container(
            decoration: BoxDecoration(
                // Gives the app bar a gradient red color
                gradient: LinearGradient(colors: <Color>[
          const Color.fromARGB(255, 249, 0, 0).withOpacity(0.9),
          const Color.fromARGB(223, 189, 0, 0).withOpacity(0.9)
        ]))),
        toolbarHeight: 100,
        );
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      // TODO: body of scaffold
    );
  }
}