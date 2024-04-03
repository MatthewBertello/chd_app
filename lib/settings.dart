///GRACE DO
import 'package:flutter/material.dart';
class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Settings'), centerTitle: true),
        body: SingleChildScrollView( // Wrapped with SingleChildScrollView to avoid overflow when keyboard appears
          padding: const EdgeInsets.all(75),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Adjusted to start to avoid centering vertically
            crossAxisAlignment: CrossAxisAlignment.start, // Stretch to width of the screen
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                 hintText: 'Current Email',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0), // Add padding
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(
                  hintText: 'New Email',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0), // Add padding
                ),
              ),
              SizedBox(height: 60.0),
              SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Current Password',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0), // Add padding
                ),
                obscureText: true, // Hide password
              ),
              SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(
                  hintText: 'New Password',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0), // Add padding
                ),
                obscureText: true, // Hide password
              ),
              SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Confirm Password',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0), // Add padding
                ),
                obscureText: true, // Hide password
              ),
              SizedBox(height: 24.0),
                 TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 3, 46, 81),
                ),
                child: Text('Delete Account'),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                 shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // Makes the button rectangular
                      side: BorderSide( width: 2.0), // border for button
                    ),
                  ),
                ), 
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0), // Add padding
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}