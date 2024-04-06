import 'package:chd_app/models/main_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HealthWidget extends StatelessWidget {
  const HealthWidget({super.key, required this.model});
  final TestModel model;

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            // Add this
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildPregnancyCountDown(
                          context), // Build and display the pregnancy countdown
                      buildHealthMeter(
                          context) // Build and display the health meter
                    ]),
                // Display the category summary
                Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: buildCategorySummary(context)),
                // Display the previous entries
                Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: buildPreviousEntries(context)),
              ],
            ),
          ),
        ));
  }

  Widget buildPreviousEntries(BuildContext context) {
    // This should be a list view that displays the top 5 previous entries and a show more button. Each entry should have a date, a health meter, and a category summary.
    // Use hardcoded data for now, will need to get from database later
    List entries = [
      {
        'date': '3-5-2024',
        'categories': 'Mental: 80%, Physical: 60%, Social: 40%'
      },
      {
        'date': '3-3-2024',
        'categories': 'Mental: 70%, Physical: 50%, Social: 30%'
      },
      {
        'date': '3-1-2024',
        'categories': 'Mental: 60%, Physical: 40%, Social: 20%'
      }
    ];
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: const BorderRadius.all(Radius.circular(30))),
      child: SizedBox(
          width: 340,
          child: Column(children: [
            Text("Previous Entries",
                style: TextStyle(
                    color: Colors.indigo[900], fontWeight: FontWeight.bold)),
            Column(
              children: entries.map((entry) {
                return Container(
                  margin: const EdgeInsets.only(
                      bottom: 10.0), // Add space between buttons
                  child: ElevatedButton(
                    onPressed: () {
                      // Add your action for the button here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[50], // background color
                      foregroundColor: Colors.indigo[900], // text color
                      side: BorderSide(
                          color: Colors.indigo[900]!, width: 1), // border color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ), // border shape
                      padding:
                          EdgeInsets.zero, // Remove padding from the button
                    ),
                    child: ListTile(
                      title: Text(
                        entry['date'],
                        style: TextStyle(color: Colors.indigo[900]),
                      ),
                      subtitle: Text(
                        entry['categories'],
                        style: TextStyle(color: Colors.indigo[900]),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(
              width: 340,
              child: ElevatedButton(
                onPressed: () {
                  // Add your action for the button here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[50], // background color
                  foregroundColor: Colors.indigo[900], // text color
                  side: BorderSide(
                      color: Colors.indigo[900]!, width: 1), // border color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ), // border shape
                ),
                child: Text('View All',
                    style: TextStyle(color: Colors.indigo[900])),
              ),
            ),
          ])),
    );
  }

  Color getProgressColor(double progress) {
    if (progress >= 0.8) {
      return Colors.green;
    } else if (progress >= 0.6) {
      return Colors.yellow;
    } else if (progress >= 0.4) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  Widget buildCategorySummary(BuildContext context) {
    // A list of categories, hardcoded for now, will need to get it from database later
    List categories = [
      {'category': 'Mental', 'progress': 80},
      {'category': 'Physical', 'progress': 60},
      {'category': 'Social', 'progress': 40}
    ];
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: const BorderRadius.all(Radius.circular(30))),
      child: SizedBox(
          width: 340,
          child: Column(children: [
            Column(
              children: categories.map((category) {
                double progress = category['progress'] /
                    100; // Convert the percentage to a double
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 5.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.indigo[900]!),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // Add your action for the button here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[50], // background color
                      foregroundColor: Colors.indigo[900], // text color
                      side: BorderSide(
                          color: Colors.indigo[900]!, width: 1), // border color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ), // border shape
                      padding:
                          EdgeInsets.zero, // Remove padding from the button
                    ),
                    child: ListTile(
                      title: Text(category['category'],
                          style: TextStyle(color: Colors.indigo[900])),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            Text(
                              "${(progress * 100).toInt()}%",
                              style: TextStyle(color: Colors.indigo[900]),
                            ),
                            const SizedBox(
                                width:
                                    5), // Add some space between the text and the progress bar
                            Expanded(
                              child: LinearProgressIndicator(
                                value: progress,
                                backgroundColor: Colors.grey[200],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    getProgressColor(progress)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ])),
    );
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

  // Builds a health meter
  Widget buildHealthMeter(BuildContext context) {
    return Container(
      // Widget displaying the health meter
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: const BorderRadius.all(Radius.circular(30))),
      child: SizedBox(
          width: 150,
          height: 150,
          child: Stack(fit: StackFit.expand, children: [
            SfCircularChart(
              series: <CircularSeries>[
                DoughnutSeries<String, Object>(
                  // Displays the doughnut according to the user's health
                  dataSource: const [
                    'Fair',
                    'Empty' // This represents the remaining 20%
                  ], // Hardcoded for now, will need to get from database later
                  xValueMapper: (datum, _) => datum,
                  yValueMapper: (datum, _) => datum == 'Empty'
                      ? 0.2
                      : 0.8, // Here we set the 'Fair' to 80% and 'Empty' to 20%
                  pointColorMapper: (datum, _) {
                    switch (datum) {
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
                      case 'Empty':
                        return Colors
                            .transparent; // This makes the remaining 20% invisible
                    }
                    return null;
                  },
                  strokeColor: Colors.white,
                ),
              ],
            ),
            const Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            Text("Health",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.indigo[900], fontWeight: FontWeight.bold))
          ])),
    );
  }

  // Builds the app bar
  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text("Health Overview",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      flexibleSpace: Container(
          decoration: BoxDecoration(
              // Gives the app bar a gradient red color
              gradient: LinearGradient(colors: <Color>[
        const Color.fromARGB(255, 249, 0, 0).withOpacity(0.9),
        const Color.fromARGB(223, 189, 0, 0).withOpacity(0.9)
      ]))),
    );
  }
}
