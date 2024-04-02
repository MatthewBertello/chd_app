import 'package:chd_app/test_model.dart';
import 'package:flutter/material.dart';
import 'shareScreen.dart';
import 'package:provider/provider.dart';
import 'settings.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Overview extends StatelessWidget {
  const Overview({required this.model});
  final TestModel model;

  // Makes the search button and navigates to shareScreen when pressed
  IconButton buildSearchButton(BuildContext context) {
    return IconButton(
              onPressed: () {
                  model.clearMembersSearched();
                  Navigator.push(
                    context,
                    MaterialPageRoute( // Navigates to shareScreen
                        builder: (context) => Consumer<TestModel> (
      builder: (context, model, child) {
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
                    MaterialPageRoute( // Navigates to settings
                        builder: (context) => Consumer<TestModel> (
      builder: (context, model, child) {
        return Settings(model: model);
      })));
                
              },
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
              ));
  }

  // Builds the app bar 
  AppBar buildAppBar(BuildContext context) {
    return AppBar(
        title: const Text("Overview", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        flexibleSpace: Container(
            decoration: BoxDecoration(
                // Gives the app bar a gradient red color
                gradient: LinearGradient(colors: <Color>[
          const Color.fromARGB(255, 249, 0, 0).withOpacity(0.9),
          const Color.fromARGB(223, 189, 0, 0).withOpacity(0.9)
        ]))),
        toolbarHeight: 100,
        actions: [
          buildSearchButton(context),
          buildSettingsButton(context)
        ]);
  }

  // Builds the widget for the pregnancy countdown
  Widget buildPregnancyCountDown(BuildContext context) {
    return Container( // Widget displaying the count down for the pregnancy
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(color: Colors.red[50],
            borderRadius: const BorderRadius.all(Radius.circular(30))),
            child: SizedBox(
              width: 150,
              height: 150,
              child: Stack( 
                fit: StackFit.expand,
                children: [ // Contains the progress indicator and the text inside it
                  CircularProgressIndicator(value: model.countDay() / model.countTotalPregnantDays(),
                  valueColor: AlwaysStoppedAnimation(Colors.purple[200]),
                  backgroundColor: Colors.purple[100],
                  ),
                  Center(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text("${model.dueDateCountDown()} Days", style: TextStyle(color: Colors.indigo[900], fontWeight: FontWeight.bold)), Icon(Icons.pregnant_woman, color: Colors.pink[100], size: 50)])),
                ],
              )
            ),
          );
  }

  // Builds a health meter 
  Widget buildHealthMeter(BuildContext context) {
    return Container( // Widget displaying the health meter
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(color: Colors.red[50],
            borderRadius: const BorderRadius.all(Radius.circular(30))),
            child: SizedBox(
              width: 150,
              height: 150,
              child: Stack(
                fit: StackFit.expand,
                children: [SfCircularChart(series: <CircularSeries> [
                  DoughnutSeries<String, Object>( // Displays the doughnut according to the user's health
                    dataSource: const ['Fair'], // Hardcoded for now, will need to get from database later
                    xValueMapper: (datum, _) => datum, yValueMapper: (datum, _) => 1,
                    pointColorMapper: (datum, _) {
                      switch(datum) {
                        case 'Excellent':
                          return Colors.green;
                        case 'Good':
                          return Colors.blue;
                        case 'Fair':
                          return Colors.yellow;
                        case 'Poor':
                          return Colors.orange;
                        case 'Unhealthy':
                          return Colors.red;
                      }
                      return null;
                    },
                    strokeColor: Colors.white,),
                  ],
                ),
                const Icon(Icons.favorite, color: Colors.red,),
                Text("Health", textAlign: TextAlign.center, style: TextStyle(color: Colors.indigo[900], fontWeight: FontWeight.bold))
                ]
              )
            ),
          );
  }

  Widget displayRecommendations(BuildContext context) {
    // List of recommendations, hardcoded for now, will need to get it from database later
    List recommendations = [{'recommendation': 'Increase sleep', 'icon': const Icon(Icons.night_shelter, color: Colors.red)},
                                    {'recommendation': 'Increase water intake', 'icon': const Icon(Icons.water_drop, color: Colors.red)},
                                    {'recommendation': 'Call PMD or OB for swelling in legs', 'icon': const Icon(Icons.call, color: Colors.red)}];

    return Container( // Widget displaying the recommendations
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(color: Colors.red[50],
            borderRadius: const BorderRadius.all(Radius.circular(30))),
            child: SizedBox(
              width: 340,
              height: 420,
              child: Column(
                children: [
                  Text("Recommendations", style: TextStyle(color: Colors.indigo[900], fontWeight: FontWeight.bold)),
                  Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) => Divider(color: Colors.white),
                      itemCount: recommendations.length,
                      itemBuilder: (context, index) {
                        return ListTile(  // Display each recommendation and corresponding icon
                          title: Text(recommendations[index]['recommendation'], style: TextStyle(color: Colors.indigo[900])),
                          trailing: recommendations[index]['icon'],
                        );
                      },)
                  ,)
                ]
              )
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: buildAppBar(context),
    body: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
        Row( 
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildPregnancyCountDown(context), // Build and display the pregnancy countdown
            buildHealthMeter(context) // Build and display the health meter
          ]
        ),
        Padding(padding: const EdgeInsets.all(15.0),
        child: displayRecommendations(context)) // Display the recommendations
      ],),
    ));
  }
}
