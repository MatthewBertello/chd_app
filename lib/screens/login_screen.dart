import 'package:chd_app/components/tab_view.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  // Congenital heart disease ribbon
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Image.network(
                      'https://www.conqueringchd.org/wp-content/uploads/2020/07/awareness-ribbon-300x300.png',
                      width: 100.0,
                      fit: BoxFit.cover)),
              const TextField(),
              const TextField(),

              ElevatedButton(
                // Button that logs user in and navigates to the home screen
                child: Text('Sign in'),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => TabView()));
                },
              ),

              // Button for user to change their password incase they forgot their password
              const TextButton(onPressed: null, child: Text('Forgot Password')),
            ],
          ),
        ),
      ]),
    );
  }
}
