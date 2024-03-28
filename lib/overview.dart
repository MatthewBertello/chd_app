import 'package:chd_app/test_model.dart';
import 'package:flutter/material.dart';

class Overview extends StatelessWidget {
  const Overview({required this.model});
  final TestModel model;

  @override 
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar(title: const Text('Overview'))
    );
  }
}