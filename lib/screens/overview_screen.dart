import 'package:chd_app/components/default_app_bar.dart';
import 'package:chd_app/components/health_meter.dart';
import 'package:chd_app/models/main_model.dart';
import 'package:flutter/material.dart';
import 'user_search_screen.dart';
import 'package:provider/provider.dart';
import 'settings_screen.dart';

class Overview extends StatelessWidget {
  const Overview({super.key, required this.model});
  final TestModel model;

  // Makes the search button and navigates to shareScreen when pressed
  IconButton buildSearchButton(BuildContext context) {
    return IconButton(
        onPressed: () {
          model.clearMembersSearched();
          Navigator.push(
              context,
              MaterialPageRoute(
                  // Navigates to shareScreen
                  builder: (context) =>
                      Consumer<TestModel>(builder: (context, model, child) {
                        return ShareScreen(model: model);
                      })));
        },
        icon: const Icon(
          Icons.search,
          color: Colors.white,
        ));
  }

  // Makes the settings button and navigates to settings when pressed
  IconButton buildSettingsButton(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  // Navigates to settings
                  builder: (context) =>
                      Consumer<TestModel>(builder: (context, model, child) {
                        return const Settings();
                      })));
        },
        icon: const Icon(
          Icons.settings,
          color: Colors.white,
        ));
  }

  // Builds the widget for the pregnancy countdown
  Widget buildPregnancyCountDown(BuildContext context) {
    return Container(
      // Widget displaying the count down for the pregnancy
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: const BorderRadius.all(Radius.circular(30))),
      child: SizedBox(
          width: 150,
          height: 150,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Contains the progress indicator and the text inside it
              CircularProgressIndicator(
                value: model.countDay() / model.countTotalPregnantDays(),
                valueColor: AlwaysStoppedAnimation(Colors.purple[200]),
                backgroundColor: Colors.purple[100],
              ),
              Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Text("${model.dueDateCountDown()} Days",
                        style: TextStyle(
                            color: Colors.indigo[900],
                            fontWeight: FontWeight.bold)),
                    Icon(Icons.pregnant_woman,
                        color: Colors.pink[100], size: 50)
                  ])),
            ],
          )),
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

    return Container(
      // Widget displaying the recommendations
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: const BorderRadius.all(Radius.circular(30))),
      child: SizedBox(
          width: 340,
          height: 420,
          child: Column(children: [
            Text("Recommendations",
                style: TextStyle(
                    color: Colors.indigo[900], fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) =>
                    const Divider(color: Colors.white),
                itemCount: recommendations.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    // Display each recommendation and corresponding icon
                    title: Text(recommendations[index]['recommendation'],
                        style: TextStyle(color: Colors.indigo[900])),
                    trailing: recommendations[index]['icon'],
                  );
                },
              ),
            )
          ])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: DefaultAppBar(title: "Overview"),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                buildPregnancyCountDown(
                    context), // Build and display the pregnancy countdown
                const HealthMeter(value: 90) // Display the health meter
              ]),
              Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: displayRecommendations(
                      context)) // Display the recommendations
            ],
          ),
        ));
  }
}
