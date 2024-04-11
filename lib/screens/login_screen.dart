import 'package:chd_app/components/tab_view.dart';
import 'package:chd_app/screens/signup_screen.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: [
            Container( // Gives app a gradient background color
              decoration: BoxDecoration(
              gradient: LinearGradient(colors: <Color>[
        const Color.fromARGB(255, 0, 4, 83).withOpacity(0.9),
        const Color.fromARGB(223, 189, 0, 0).withOpacity(0.9)
      ]))
            ),

            Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding( // Congenital heart disease ribbon
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Image.network('https://www.conqueringchd.org/wp-content/uploads/2020/07/awareness-ribbon-300x300.png',width:100.0, fit:BoxFit.cover)),

                const Padding( // Textfield to enter email
                  padding: EdgeInsets.only(bottom: 20),
                  child: TextField(
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Email',
                            enabledBorder: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(),
                            contentPadding: EdgeInsets.all(8.0),
                            constraints: BoxConstraints(maxHeight: 45.0, maxWidth: 300)),
                      ),
                ),
                        
                const Padding( // Textfield to enter password
                  padding: EdgeInsets.only(bottom: 20),
                  child: TextField(
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Password',
                            enabledBorder: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(),
                            contentPadding: EdgeInsets.all(8.0),
                            constraints: BoxConstraints(maxHeight: 45.0, maxWidth: 300)),
                      ),
                ),
                        
                ElevatedButton( // Button that navigates to sign up screen
                  style: const ButtonStyle(fixedSize: MaterialStatePropertyAll<Size>(Size(300, 20))),
                  child: Text('Sign up', style: TextStyle(color: Colors.indigo[900]),),
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
                  },
                ),

                ElevatedButton( // Button that logs user in and navigates to the home screen
                  style: const ButtonStyle(fixedSize: MaterialStatePropertyAll<Size>(Size(300, 20))),
                  child: Text('Sign in', style: TextStyle(color: Colors.indigo[900])),
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TabView()));
                  },
                ),

                // Button for user to change their password incase they forgot their password
                const TextButton(onPressed: null, child: Text('Forgot Password', style: TextStyle(color: Colors.white))),
              ],
                        ),
            ),]
        ),
      );
  }
}
