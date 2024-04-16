import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:chd_app/components/default_app_bar.dart';

class RecommendationPage extends StatelessWidget {
  final String? recommendation;
  final String? goal;
  final String? educationalInfo;
  
  RecommendationPage({this.recommendation, this.goal, this.educationalInfo});

  @override 
  Widget build(BuildContext context) {
    return Scaffold(appBar: DefaultAppBar(context: context, title: Text(recommendation!)),);
  }
}