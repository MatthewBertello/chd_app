import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'test_model.dart';

class ShareScreen extends StatelessWidget {
  const ShareScreen({required this.model});
  final TestModel model;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      backgroundColor: Colors.red,
      title: const Text(
        'Share With Others',
        style: TextStyle(color: Colors.white),
      ),
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(40.0),
            child: TextField(
              maxLines: 1,
              style: TextStyle(fontSize: 15),
              decoration: InputDecoration(
                  suffixIcon: IconButton(onPressed: null, icon: Icon(Icons.search)),
                  hintText: 'Find a Member',
                  filled: true,
                  fillColor: Colors.white),
            ),
          ),
        ),
      );
  }
}
