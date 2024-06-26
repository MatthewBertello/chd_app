import 'package:heart_safe/components/default_app_bar.dart';
import 'package:heart_safe/models/variable_entries_model.dart';
import 'package:heart_safe/screens/variable_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
///Author: Pachia Lee, Grace Kiesau, Matthew Bertello 
///Date: 5/14/24
///Description: gets variable entries from the db
///Bugs: None Known
class EntryScreen extends StatelessWidget {
  final DateTime startDate;

  @override
  const EntryScreen({required this.startDate, super.key});

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
        .getVariableEntriesFromDate(
            date: startDate,
            entries:
                Provider.of<VariableEntriesModel>(context).variableEntries);
    entries.sort((entry1, entry2) => entry1['date'].compareTo(entry2['date']));
    return Scaffold(
        appBar: DefaultAppBar(
            context: context, title: Text(DateFormat.yMd().format(startDate))),
        body: ListView.separated(
          separatorBuilder: (context, index) => const Divider(),
          itemCount: entries.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(entries[index]['name']),
              subtitle: Text(DateFormat.jm().format(entries[index]['date'])),
              trailing: Text(entries[index]['value'].toString()),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VariableScreen(
                      variableId: entries[index]["variable_id"],
                    ),
                  ),
                );
              },
            );
          },
        ));
  }
}
