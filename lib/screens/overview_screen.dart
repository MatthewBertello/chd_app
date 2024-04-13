import 'package:chd_app/components/default_app_bar.dart';
import 'package:chd_app/components/health_meter.dart';
import 'package:chd_app/components/pregnancy_countdown.dart';
import 'package:chd_app/models/main_model.dart';
import 'package:flutter/material.dart';

class Overview extends StatelessWidget {
  const Overview({super.key, required this.model});
  final MainModel model;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: DefaultAppBar(title: "Overview"),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            SizedBox(
              width: screenWidth / 2,
              height: screenWidth / 2,
              child: const PregnancyCountdown(currentDays: 131, totalDays: 270),
            ),
            SizedBox(
              width: screenWidth / 2,
              height: screenWidth / 2,
              child: const HealthMeter(value: 90),
            )
          ]),
          displayRecommendations(context)
        ],
      ),
    );
  }

  Widget displayRecommendations(BuildContext context) {
    // List of recommendations, hardcoded for now, will need to get it from database later
    List recommendations = [
      {
        'recommendation': 'Increase sleep',
        'icon': const Icon(Icons.night_shelter, color: Colors.red)
      },
      {
        'recommendation': 'Increase water intake',
        'icon': const Icon(Icons.water_drop, color: Colors.red)
      },
      {
        'recommendation': 'Call PMD or OB for swelling in legs',
        'icon': const Icon(Icons.call, color: Colors.red)
      }
    ];

    return Expanded(
      child: Column(
        children: [
          const Text("Recommendations"),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              itemCount: recommendations.length,
              itemBuilder: (context, index) {
                return ListTile(
                  // Display each recommendation and corresponding icon
                  title: Text(recommendations[index]['recommendation']),
                  trailing: recommendations[index]['icon'],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
