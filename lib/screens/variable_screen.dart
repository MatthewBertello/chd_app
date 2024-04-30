import 'package:chd_app/components/default_app_bar.dart';
import 'package:chd_app/models/info_entry_model.dart';
import 'package:chd_app/models/variable_entries_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class VariableScreen extends StatelessWidget {
  final int variableId;
  List<int> values = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

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
    entries.sort((entry1, entry2) => entry1['date'].compareTo(entry2['date']));
    List<FlSpot> spots = entries
        .map((entry) => FlSpot(
            entries.indexOf(entry).toDouble(), entry['value'].toDouble()))
        .toList();
    return Scaffold(
        appBar: DefaultAppBar(
            context: context,
            title: Text(Provider.of<VariableEntriesModel>(context)
                .variableDefinitions
                .firstWhere((element) => element['id'] == variableId)['name'])),
        body: Column(
          children: [
            Container(
              height: 200,
              child: LineChart(
                LineChartData(
                  minY: 0,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                      curveSmoothness: 0.1,
                    )
                  ],
                ),
              ),
            ),
            ListView.separated(
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
                    trailing: Text(entries[reversedIndex]['value'].toString()));
              },
            ),
          ],
        ));
  }
}
