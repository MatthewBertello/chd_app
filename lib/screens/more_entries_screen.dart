import 'package:chd_app/components/default_app_bar.dart';
import 'package:chd_app/models/variable_entries_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'entry_screen.dart';

class MoreEntriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        context: context,
        title: const Text("Previous Entries"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: buildPreviousEntries(context),
        ),
      ),
    );
  }

  Widget buildPreviousEntries(BuildContext context) {
    List entries = Provider.of<VariableEntriesModel>(context).dates;

    print(entries);
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: entries.length,
      itemBuilder: (context, index) {
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
      },
      separatorBuilder: (context, index) {
        return const Divider(
          height: 1,
        );
      },
    );
  }
}