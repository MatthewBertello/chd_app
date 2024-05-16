import 'package:flutter/material.dart';
import 'package:heart_safe/components/default_app_bar.dart';
import 'package:heart_safe/components/tile.dart';

///Author: Matthew Bertello
///Description: This is the file that allows the meter to change based on the rolling data entered
///Date: 5/14/24
///Bugs: None Known
///reflection: 
class RecommendationPage extends StatelessWidget {
  final String? recommendation;
  final String? name;
  final double innerMargin = 15;

  
  const RecommendationPage({super.key, this.name, this.recommendation });

  Column makeRecommendationText(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        (name != null) ? Text('$name\n') : const Text(''),
        (recommendation != null) ? Text('$recommendation'): const Text('')
      ],
    );
  }
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(context: context, title: const Text('Recommendation')),
      body: Column(
        children: [
          Tile(
            margin: EdgeInsets.all(innerMargin),
            padding: const EdgeInsets.all(10),
            child: makeRecommendationText(context),)
        ],)
    );
  }
}