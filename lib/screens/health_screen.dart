import 'package:chd_app/components/default_app_bar.dart';
import 'package:chd_app/components/health_meter.dart';
import 'package:chd_app/components/pregnancy_countdown.dart';
import 'package:chd_app/models/main_model.dart';
import 'package:flutter/material.dart';

class HealthWidget extends StatelessWidget {
  const HealthWidget({super.key, required this.model});
  final MainModel model;

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: "Health",
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PregnancyCountdown(currentDays: 131, totalDays: 270),
                HealthMeter(value: 90),
              ]),
          buildCategorySummary(context),
          buildPreviousEntries(context),
        ],
      ),
    );
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
    return Column(
      children: [
        const Text("Previous Entries"),
        Column(
          children: entries.map(
            (entry) {
              return ListTile(
                title: Text(
                  entry['date'],
                ),
                subtitle: Text(
                  entry['categories'],
                ),
              );
            },
          ).toList(),
        ),
        ListTile(
          title: const Text("Show More"),
          onTap: () {
            // Show more entries
          },
        )
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
        Column(
          children: categories.map(
            (category) {
              return ListTile(
                title: Text(
                  category['category'],
                ),
                trailing: SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      Text("${category['progress'].toInt()}%"),
                      const SizedBox(width: 5),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: category['progress'] / 100,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            getProgressColor(category['progress']),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ],
    );
  }
}
