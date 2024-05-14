import 'package:heart_safe/components/default_app_bar.dart';
import 'package:heart_safe/models/info_entry_model.dart';
import 'package:heart_safe/models/variable_entries_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class VariableScreen extends StatelessWidget {
  final int variableId;
  // set the startdate to 1 month ago
  final DateTime startDate = DateTime.now().subtract(Duration(days: 35));

  @override
  VariableScreen({required this.variableId, super.key});

  @override
  Widget build(BuildContext context) {
    // Makes sure that data is pulled in
    if (Provider.of<VariableEntriesModel>(context, listen: false).loaded ==
            false &&
        Provider.of<VariableEntriesModel>(context, listen: false).loading ==
            false) {
      Provider.of<VariableEntriesModel>(context, listen: false).init();
    }

    List entries = Provider.of<VariableEntriesModel>(context)
        .getVariableEntriesById(
            id: variableId,
            entries:
                Provider.of<VariableEntriesModel>(context).variableEntries);
    double average = entries
            .map((entry) => entry['value'])
            .reduce((value, element) => value + element) /
        entries.length;
    entries =
        entries.where((entry) => entry['date'].isAfter(startDate)).toList();
    entries = entries
        .where((entry) =>
            entry['date'].isBefore(DateTime.now().add(Duration(days: 1))))
        .toList();
    entries.sort((entry1, entry2) => entry1['date'].compareTo(entry2['date']));
    double averageLastFiveWeeks = entries
            .map((entry) => entry['value'])
            .reduce((value, element) => value + element) /
        entries.length;

    List<FlSpot> spots = entries
        .map((entry) => FlSpot(
            entry['date'].difference(DateTime.now()).inDays.toDouble(),
            entry['value'].toDouble()))
        .toList();
    return Scaffold(
        appBar: DefaultAppBar(
            context: context,
            title: Text(Provider.of<VariableEntriesModel>(context)
                .variableDefinitions
                .firstWhere((element) => element['id'] == variableId)['name'])),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                height: 250,
                child: LineChart(
                  LineChartData(
                    minX: -35.0,
                    maxX: 0,
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                        curveSmoothness: 0.01,
                      )
                    ],
                    titlesData: FlTitlesData(
                      show: true,
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        axisNameWidget: Text('Date'),
                        sideTitles: SideTitles(
                          // set the interval to the difference between the first and last date
                          interval: 7,
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              DateFormat.Md().format(DateTime.now()
                                  .add(Duration(days: value.toInt()))),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Text('Overall Average'),
                subtitle: Text(
                  double.parse(average.toStringAsFixed(2)).toString(),
                ),
              ),
              ListTile(
                title: Text('Average Last 5 Weeks'),
                subtitle: Text(
                    double.parse(averageLastFiveWeeks.toStringAsFixed(2))
                        .toString()),
              ),
              Text('Previous Entries'),
              const Divider(),
              ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) => const Divider(),
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  var reversedIndex = entries.length - index - 1;
                  return ListTile(
                      title: Text(entries[reversedIndex]['name']),
                      subtitle: Text(DateFormat.yMd()
                          .add_jm()
                          .format(entries[reversedIndex]['date'])),
                      trailing:
                          Text(entries[reversedIndex]['value'].toString()));
                },
              ),
            ],
          ),
        ));
  }
}
