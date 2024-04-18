import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:chd_app/components/default_app_bar.dart';
import 'package:chd_app/components/tile.dart';

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