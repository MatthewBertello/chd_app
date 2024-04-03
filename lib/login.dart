import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key, required this.updatePage});

  final void Function(int) updatePage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
              // Gives the app bar a gradient red color
              gradient: LinearGradient(colors: <Color>[
        Color.fromARGB(255, 0, 4, 83).withOpacity(0.9),
        const Color.fromARGB(223, 189, 0, 0).withOpacity(0.9)
      ]))
            ),

            Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Image.network('https://www.conqueringchd.org/wp-content/uploads/2020/07/awareness-ribbon-300x300.png',width:100.0, fit:BoxFit.cover)),

                const Padding(
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
                        
                const Padding(
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
                        
                ElevatedButton(
                  style: const ButtonStyle(fixedSize: MaterialStatePropertyAll<Size>(Size(300, 20))),
                  child: Text('Sign up', style: TextStyle(color: Colors.indigo[900]),),
                  onPressed: () {
                    updatePage(2);
                  },
                ),
                ElevatedButton(
                  style: const ButtonStyle(fixedSize: MaterialStatePropertyAll<Size>(Size(300, 20))),
                  child: Text('Sign in', style: TextStyle(color: Colors.indigo[900])),
                  onPressed: () {
                    updatePage(1);
                  },
                )
              ],
                        ),
            ),]
        ),
      );
  }
}
