import 'package:flutter/material.dart';
import 'package:heart_safe/components/default_app_bar.dart';
import 'package:heart_safe/components/tile.dart';

///Author: 
///Description: This is the file that allows the meter to change based on the rolling data entered
///Date: 5/14/24
///Bugs: None Known
class RecommendationPage extends StatelessWidget {
  final String? recommendation;
  final String? goal;
  final String? educationalInfo;
  final double innerMargin = 15;
  
  const RecommendationPage({super.key, this.recommendation, this.goal, this.educationalInfo});

  Column makeRecommendationText(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text('$recommendation', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
        (goal != null) ? Text('\nGoal: $goal\n') : const Text(''),
        (educationalInfo != null) ? Text('$educationalInfo'): const Text('')
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