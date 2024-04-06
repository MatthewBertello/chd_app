///GRACE DO
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      
      title: const Text("Settings",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
      body: SingleChildScrollView(
        // Wrapped with SingleChildScrollView to avoid overflow when keyboard appears
        padding: const EdgeInsets.all(75),
        child: Column(
          mainAxisAlignment: MainAxisAlignment
              .start, // Adjusted to start to avoid centering vertically
          crossAxisAlignment:
              CrossAxisAlignment.start, // Stretch to width of the screen
          children: <Widget>[
            const TextField(
              decoration: InputDecoration(
                hintText: 'Current Email',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 15.0), // Add padding
              ),
            ),
            const SizedBox(height: 16.0),
            const TextField(
              decoration: InputDecoration(
                hintText: 'New Email',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 15.0), // Add padding
              ),
            ),
            const SizedBox(height: 60.0),
            const SizedBox(height: 16.0),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Current Password',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 15.0), // Add padding
              ),
              obscureText: true, // Hide password
            ),
            const SizedBox(height: 16.0),
            const TextField(
              decoration: InputDecoration(
                hintText: 'New Password',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 15.0), // Add padding
              ),
              obscureText: true, // Hide password
            ),
            const SizedBox(height: 16.0),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Confirm Password',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 15.0), // Add padding
              ),
              obscureText: true, // Hide password
            ),
            const SizedBox(height: 24.0),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 3, 46, 81),
              ),
              child: const Text('Delete Account'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0), // Add padding
                  child: Text('Submit', style: TextStyle(color: Colors.white)),
                ),
              ),]
            ),
          ],
        ),
      ),
    );
  }
}
