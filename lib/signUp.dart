import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key, required this.updatePage});

  void Function(int) updatePage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Sign Up',
                style: TextStyle(fontWeight: FontWeight.bold)),
            centerTitle: true,
            backgroundColor: Colors.red,
            foregroundColor: Colors.white),
        body: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 8.0, bottom: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              // Where the user enters their first name
              const Text("First Name:", style: TextStyle(fontWeight: FontWeight.bold)),
              const TextField(
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(8.0),
                    constraints: BoxConstraints(maxHeight: 45.0)),
              ),
              const SizedBox(height: 20.0),
              
              // Where the user enters their last name
              const Text("Last Name:", style: TextStyle(fontWeight: FontWeight.bold)),
              const TextField(
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(8.0),
                      constraints: BoxConstraints(maxHeight: 45.0))),
              const SizedBox(height: 20.0),
             
              // Where the user enters their email
              const Text("Email:", style: TextStyle(fontWeight: FontWeight.bold)),
              const TextField(
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(8.0),
                    constraints: BoxConstraints(maxHeight: 45.0)),
              ),
              const SizedBox(height: 20.0),
             
              // Where the user enters their password
              const Text("Password:", style: TextStyle(fontWeight: FontWeight.bold)),
              const TextField(
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(8.0),
                    constraints: BoxConstraints(maxHeight: 45.0)),
              ),
              const SizedBox(height: 20.0),             
             
              // Where the user confirms their password
              const Text("Confirm Password:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const TextField(
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(8.0),
                    constraints: BoxConstraints(maxHeight: 45.0)),
              ),
              const SizedBox(height: 20.0),              
              
              // the button for creating an account
              Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 8.0, bottom: 5.0),
                      child: ElevatedButton(
                          onPressed: _dummyFunction,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              foregroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))),
                          child: const Text("Create Account"))))
            ],
          ),
        )
    );
  }

  void _dummyFunction(){
    updatePage(3);
  }

}