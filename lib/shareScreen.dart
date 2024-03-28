import 'package:flutter/material.dart';
import 'test_model.dart';

class ShareScreen extends StatelessWidget {
  const ShareScreen({required this.model});
  final TestModel model;

  @override 
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Jane Doe')),);
  }

}