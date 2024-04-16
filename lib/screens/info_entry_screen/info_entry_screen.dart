import 'dart:ffi';

import 'package:chd_app/components/default_app_bar.dart';
import 'package:chd_app/models/main_model.dart';
import 'package:chd_app/screens/info_entry_screen/variable_select_bottom_sheet.dart';
import 'package:chd_app/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DailyInfoWidget extends StatefulWidget {
  const DailyInfoWidget({super.key});

  @override
  State<DailyInfoWidget> createState() => _DailyInfoWidgetState();
}

class _DailyInfoWidgetState extends State<DailyInfoWidget> {
  bool checkboxValue = false;
  List<bool> checkboxValues = List.filled(10, false);
  @override
  Widget build(BuildContext context) {
    print("Build");
    return Scaffold(
      appBar: DefaultAppBar(
        context: context,
        title: const Text('Info Entry'),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.save),
              color: Theme.of(context).colorScheme.onPrimary),
        ],
      ),
      body: Column(
        children: [
          const Text("Test"),
          ListTile(
            title: Text("Test"),
            trailing: Checkbox(
              value: checkboxValue,
              onChanged: (bool? value) {
                setState(() {
                  checkboxValue = value!;
                });
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            // builder: _bottomSheetBuilder,
            builder: (BuildContext context) {
              return VariableSelectBottomSheet();
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
