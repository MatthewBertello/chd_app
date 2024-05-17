import 'package:heart_safe/components/default_app_bar.dart';
import 'package:heart_safe/components/health_meter.dart';
import 'package:heart_safe/components/pregnancy_countdown.dart';
import 'package:heart_safe/components/tile.dart';
import 'package:heart_safe/models/main_model.dart';
import 'package:heart_safe/models/meter_model.dart';
import 'package:heart_safe/screens/overview/pregnancy_planner.dart';
import 'package:flutter/material.dart';
import 'recommendationPage.dart';
import 'package:heart_safe/models/pregnancy_model.dart';
import 'package:provider/provider.dart';

///Author: Matthew Bertello, Pachia Lee, Grace Kiesau
///Date: 5/14/24
///Description: diaplays health status, pregnancy countdown and some recomendations
///Bugs: None Known
///reflection: straightforward

// Builds the Overview screen
class Overview extends StatelessWidget {
  const Overview({super.key, required this.model});
  final MainModel model;
  final double innerMargin = 15;
  final double outerPadding = 20;

  ///This shows the overview screen
  @override
  Widget build(BuildContext context) {
    if (Provider.of<MeterModel>(context, listen: false).loaded == false &&
        Provider.of<MeterModel>(context, listen: false).loading == false) {
      Provider.of<MeterModel>(context, listen: false).init();
    }
    if (Provider.of<PregnancyModel>(context, listen: false).loaded == false &&
        Provider.of<PregnancyModel>(context, listen: false).loading == false) {
      Provider.of<PregnancyModel>(context, listen: false).init();
    }

    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: DefaultAppBar(context: context, title: const Text("Overview")),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(outerPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                // For the pregnancy countdown
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PregnancyProgress())),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: screenWidth / 2 - outerPadding,
                        height: screenWidth / 2 - outerPadding,
                        child: PregnancyCountdown(
                          currentDays: Provider.of<PregnancyModel>(context)
                              .currentPregnantDays,
                          totalDays: Provider.of<PregnancyModel>(context)
                              .totalPregnantDays,
                          margin: EdgeInsets.all(innerMargin),
                        ),
                      ),
                      GestureDetector(
                        // For the health meter
                        onTap: () =>
                            DefaultTabController.of(context).animateTo(1),
                        child: SizedBox(
                          width: screenWidth / 2 - outerPadding,
                          height: screenWidth / 2 - outerPadding,
                          child: HealthMeter(
                            value: Provider.of<MeterModel>(context)
                                    .getTotalStatusPercentage() *
                                100,
                            margin: EdgeInsets.all(innerMargin),
                          ),
                        ),
                      )
                    ]),
              ),
              // Displays all the recommendations
              Tile(
                margin: EdgeInsets.all(innerMargin),
                child: displayRecommendations(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///Displays recommendations for users based on average values of the rolling data entered (triggered if they are too low)
  Widget displayRecommendations(BuildContext context) {
    if (Provider.of<MeterModel>(context).outOfRangeVars.isEmpty) {
      return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 2,
          child: const Center(child: Text('No recommendations to display.')));
    } else {
      return Column(children: [
        const Text("Targeted Suggestions",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => const Divider(),
          itemCount: Provider.of<MeterModel>(context).outOfRangeVars.length,
          itemBuilder: (context, index) {
            return ListTile(
                // Display each recommendation and corresponding icon
                title: Text(Provider.of<MeterModel>(context)
                    .outOfRangeVars[index]['name']),
                subtitle: Provider.of<MeterModel>(context).outOfRangeVars[index]
                            ['description'] ==
                        null
                    ? null
                    : Text(
                        '${((Provider.of<MeterModel>(context).outOfRangeVars[index]['description']) ?? "").substring(0, Provider.of<MeterModel>(context).outOfRangeVars[index]['description'].length > 70 ? 70 : Provider.of<MeterModel>(context).outOfRangeVars[index]['description'].length - 1)}...',
                      ),
                onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecommendationPage(
                          name: Provider.of<MeterModel>(context)
                              .outOfRangeVars[index]['name'],
                          recommendation: Provider.of<MeterModel>(context)
                              .outOfRangeVars[index]['description'],
                        ),
                      ),
                    ));
          },
        ),
      ]);
    }
  }
}
