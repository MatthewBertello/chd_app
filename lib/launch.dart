///GRACE DO
import 'login.dart';
import 'signUp.dart';
import 'package:flutter/material.dart';
class LaunchScreen extends StatelessWidget {
  const LaunchScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network('https://www.conqueringchd.org/wp-content/uploads/2020/07/awareness-ribbon-300x300.png',width:100.0, fit:BoxFit.cover),
            Text('Your personalized CHD asistant'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => login()),
                    // );
                  },
                   style: ButtonStyle(
                   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // Makes the button rectangular
                      side: BorderSide(color: Colors.blue, width: 2.0), // blue boarder for the button
                    ),
                  ),
                ),
                  child: Text('Log in'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => signUp()),
                    // );
                  },
                   style: ButtonStyle(
                 shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // Makes the button rectangular
                      side: BorderSide(color: Colors.red, width: 2.0), // red border for button
                    ),
                  ),
                ), 
                   child: Text('Get Started'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}