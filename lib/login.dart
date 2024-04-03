import 'package:chd_app/signUp.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {

  // Builds the app bar for login page
  AppBar buildAppBar(BuildContext context) {
    return AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration( // Gives the app bar a gradient red color 
            gradient: LinearGradient(colors:  <Color>[const Color.fromARGB(255, 249, 0, 0).withOpacity(0.9), const Color.fromARGB(223, 189, 0, 0).withOpacity(0.9)]))
        ),
    );
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: ElevatedButton(child: Text('Sign up'), onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignUpScreen()
          )
        );
      },)
    );
  }
}