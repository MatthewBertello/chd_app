import 'package:flutter/material.dart';

class DefaultAppBar extends AppBar {
  DefaultAppBar({Key? key, required String title})
      : super(
          key: key,
          title: Text(
            title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              // Gives the app bar a gradient red color
              gradient: LinearGradient(
                colors: <Color>[
                  const Color.fromARGB(255, 249, 0, 0).withOpacity(0.9),
                  const Color.fromARGB(223, 189, 0, 0).withOpacity(0.9)
                ],
              ),
            ),
          ),
        );
}
