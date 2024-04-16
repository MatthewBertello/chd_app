import 'package:chd_app/components/default_app_bar.dart';
import 'package:chd_app/components/health_meter.dart';
import 'package:chd_app/components/pregnancy_countdown.dart';
import 'package:chd_app/components/tile.dart';
import 'package:chd_app/models/main_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'recommendationPage.dart';
import 'package:provider/provider.dart';
import 'health_screen.dart';

class Overview extends StatelessWidget {
  const Overview({super.key, required this.model});
  final MainModel model;
  final double innerMargin = 15;
  final double outerPadding = 20;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: DefaultAppBar(context: context, title: Text("Overview")),
      body: Padding(
        padding: EdgeInsets.all(outerPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              SizedBox(
                width: screenWidth / 2 - outerPadding,
                height: screenWidth / 2 - outerPadding,
                child: PregnancyCountdown(
                  currentDays: 131,
                  totalDays: 270,
                  margin: EdgeInsets.all(innerMargin),
                ),
              ),
              GestureDetector(
                onTap: () => DefaultTabController.of(context).animateTo(1),
                child: SizedBox(
                  width: screenWidth / 2 - outerPadding,
                  height: screenWidth / 2 - outerPadding,
                  child: HealthMeter(
                    value: 90,
                    margin: EdgeInsets.all(innerMargin),
                  ),
                  
                ),
              )
            ]),
            Expanded(
              child: Tile(
                margin: EdgeInsets.all(innerMargin),
                child: displayRecommendations(context),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget displayRecommendations(BuildContext context) {
    // List of recommendations, hardcoded for now, will need to get it from database later
    List recommendations = [
      {
        'recommendation': 'Increase sleep',
        'icon': const Icon(Icons.night_shelter, color: Colors.red),
        'goal': 'Try to get 8-10 hours of sleep per night',
        'educational info': 'Sleep is essential for all sorts of vital bodily functions, restoring energy and allowing the brain to process new information it has taken in while awake.'
      },
      {
        'recommendation': 'Increase water intake',
        'icon': const Icon(Icons.water_drop, color: Colors.red),
        'goal': 'During pregnancy you should drink 8 to 12 cups (64 to 96 ounces) of water every day.',
        'educational info': 'Water has many benefits. It aids digestion and helps form the amniotic fluid around the fetus. Water also helps nutrients circulate in the body and helps waste leave the body.'
      },
      {
        'recommendation': 'Call PMD or OB for swelling in legs',
        'icon': const Icon(Icons.call, color: Colors.red),
        'goal': null,
        'educational info': 'For additional information, kindly refer to your provider.'
      }
    ];

    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(),
      itemCount: recommendations.length,
      itemBuilder: (context, index) {
        return ListTile(
          // Display each recommendation and corresponding icon
          title: Text(recommendations[index]['recommendation']),
          trailing: recommendations[index]['icon'],
          onTap: () => Navigator.push(context, 
                        MaterialPageRoute(builder: (context) =>
                        RecommendationPage(recommendation: recommendations[index]['recommendation'],
                        goal: recommendations[index]['goal'],
                        educationalInfo: recommendations[index]['educational info'],)))
        );
      },
    );
  }
}
