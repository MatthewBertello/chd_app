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

  Text makeRecommendationText(BuildContext context) {
    return Text(
      '$recommendation\n\n$goal\n\n$educationalInfo'
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