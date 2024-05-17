import 'package:heart_safe/components/default_app_bar.dart';
import 'package:heart_safe/components/health_meter.dart';
import 'package:heart_safe/components/pregnancy_countdown.dart';
import 'package:heart_safe/components/tile.dart';
import 'package:heart_safe/models/main_model.dart';
import 'package:heart_safe/models/pregnancy_model.dart';
import 'package:heart_safe/models/variable_entries_model.dart';
import 'package:heart_safe/screens/entry_screen.dart';
import 'package:heart_safe/screens/more_entries_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:heart_safe/models/meter_model.dart';
///Author: Pachia Lee, Grace Kiesau, Matthew Bertello
///Date: 5/14/24
///Description: displays health scores and pregnancy counter
///Bugs: None Known
class HealthWidget extends StatelessWidget {
  const HealthWidget({super.key, required this.model});
  final MainModel model;
  final double innerMargin = 15;
  final double outerPadding = 20;

  @override
  Widget build(BuildContext context) {
    if (Provider.of<VariableEntriesModel>(context, listen: false).loaded ==
            false &&
        Provider.of<VariableEntriesModel>(context, listen: false).loading ==
            false) {
      Provider.of<VariableEntriesModel>(context, listen: false).init();
    }
    if (Provider.of<MeterModel>(context, listen: false).loaded ==
            false &&
        Provider.of<MeterModel>(context, listen: false).loading ==
            false) {
      Provider.of<MeterModel>(context, listen: false).init();
    }
    if (Provider.of<PregnancyModel>(context, listen: false).loaded ==
            false &&
        Provider.of<PregnancyModel>(context, listen: false).loading ==
            false) {
      Provider.of<PregnancyModel>(context, listen: false).init();
    }

    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: DefaultAppBar(
        context: context,
        title: const Text("Health"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(outerPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                SizedBox(
                  width: screenWidth / 2 - outerPadding,
                  height: screenWidth / 2 - outerPadding,
                  child: PregnancyCountdown(
                    currentDays: Provider.of<PregnancyModel>(context).currentPregnantDays,
                    totalDays: Provider.of<PregnancyModel>(context).totalPregnantDays,
                    margin: EdgeInsets.all(innerMargin),
                  ),
                ),
                SizedBox(
                  width: screenWidth / 2 - outerPadding,
                  height: screenWidth / 2 - outerPadding,
                  child: HealthMeter(
                    value:Provider.of<MeterModel>(context).getTotalStatusPercentage() * 100,
                    margin: EdgeInsets.all(innerMargin),
                  ),
                )
              ]),
              Tile(
                margin: EdgeInsets.all(innerMargin),
                padding: const EdgeInsets.all(0),
                child: buildCategorySummary(context),
              ),
              Tile(
                margin: EdgeInsets.all(innerMargin),
                padding: const EdgeInsets.all(0),
                child: buildPreviousEntries(context),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Returns a widget that displays the category summaries
  Widget buildCategorySummary(BuildContext context) {
    // A list of categories, hardcoded for now, will need to get it from database later
    List categories = [
      {'category': 'Mental', 'progress': 80},
      {'category': 'Physical', 'progress': 60},
      {'category': 'Social', 'progress': 40}
    ];
    return Column(
      children: [
        const Text("Category Summary"),
        const Divider(height: 1),
        // The list of categories with progress bars
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                categories[index]['category'],
              ),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    Text("${categories[index]['progress'].toInt()}%"),
                    const SizedBox(width: 5),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: categories[index]['progress'] / 100,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          getProgressColor(categories[index]['progress']),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(
              height: 1,
            );
          },
        ),
      ],
    );
  }

  // Returns a widget that displays the previous entries
  Widget buildPreviousEntries(BuildContext context) {
    List entries = Provider.of<VariableEntriesModel>(context).dates;

    return Column(
      children: [
        const Text("Previous Entries"),
        const Divider(height: 1),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: (entries.length > 3) ? 4 : entries.length + 1,
          itemBuilder: (context, index) {
            if (index < entries.length && index < 3) {
              return ListTile(
                  dense: true,
                  title: Text(
                    DateFormat.yMd().format(entries[index]),
                  ),
                  // subtitle: Text(
                  //   entries[index]['categories'],
                  // ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EntryScreen(
                          startDate: entries[index],
                        ),
                      ),
                    );
                  });
            } else {
              return ListTile(
                // align the text to the center
                title: const Text("Show More", textAlign: TextAlign.center),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MoreEntriesScreen(),
                    ),
                  );
                },
              );
            }
          },
          separatorBuilder: (context, index) {
            return const Divider(
              height: 1,
            );
          },
        ),
      ],
    );
  }

  Color getProgressColor(int progress) {
    if (progress >= 80) {
      return Colors.green;
    } else if (progress >= 60) {
      return Colors.yellow;
    } else if (progress >= 40) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
