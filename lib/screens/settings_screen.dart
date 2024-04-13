///GRACE DO
import 'package:chd_app/components/default_app_bar.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: 'Settings'),
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
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0), // Add padding
                  child: Text('Submit'),
                ),
              ),]
            ),
          ],
        ),
      ),
    );
  }
}
