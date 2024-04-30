import 'package:chd_app/components/default_app_bar.dart';
import 'package:chd_app/models/info_entry_model.dart';
import 'package:chd_app/models/variable_entries_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class VariableScreen extends StatelessWidget {
  final int variableId;

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
    return Scaffold(
        appBar: DefaultAppBar(
            context: context,
            title: Text(Provider.of<VariableEntriesModel>(context)
                .variableDefinitions
                .firstWhere((element) => element['id'] == variableId)['name'])),
        body: ListView.separated(
          separatorBuilder: (context, index) => const Divider(),
          itemCount: entries.length,
          itemBuilder: (context, index) {
            return ListTile(
                title: Text(entries[index]['name']),
                subtitle: Text(DateFormat.jm().format(entries[index]['date'])),
                trailing: Text(entries[index]['value'].toString()));
          },
        ));
  }
}
