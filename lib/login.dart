import 'package:chd_app/signUp.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  Login({super.key, required this.updatePage});

  final void Function(int) updatePage;

  // Builds the app bar for login page
  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
          decoration: BoxDecoration(
              // Gives the app bar a gradient red color
              gradient: LinearGradient(colors: <Color>[
        const Color.fromARGB(255, 249, 0, 0).withOpacity(0.9),
        const Color.fromARGB(223, 189, 0, 0).withOpacity(0.9)
      ]))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Column(
        children: [
          ElevatedButton(
            child: Text('Sign up'),
            onPressed: () {
              updatePage(2);
            },
          ),
          ElevatedButton(
            child: Text('Sign in'),
            onPressed: () {
              updatePage(1);
            },
          )
        ],
      ),
    );
  }
}
