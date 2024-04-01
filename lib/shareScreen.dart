// ignore: file_names
import 'package:flutter/material.dart';
import 'test_model.dart';

class ShareScreen extends StatefulWidget {
  const ShareScreen({super.key, required this.model});
  final TestModel model;

  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {

  // Builds an app bar with a textfield to search for members in the app
  AppBar buildAppBar(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.red[600],
        title: Container(
          padding: const EdgeInsets.all(3.0),
          height: 45,
          width: 350, 
          child: TextField(
            textAlign: TextAlign.start,
            maxLines: 1,
            style: TextStyle(fontSize: 15, color: Colors.indigo[900]),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              alignLabelWithHint: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              hintText: 'Find a Member',
              filled: true,
              fillColor: Colors.white,
              suffixIcon: IconButton(onPressed: null, icon: Icon(Icons.search, color: Colors.blueGrey[400]),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context));
  }
}
