import 'dart:ffi';

import 'package:chd_app/components/default_app_bar.dart';
import 'package:chd_app/models/main_model.dart';
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
              return SizedBox(
      height: 600,
      child: Center(
        child: Scaffold(
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchBar(
                  hintText: "Search",
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text("Test $index"),
                      trailing: Checkbox(
                        value: checkboxValues[index],
                        onChanged: (bool? value) {
                          print("Checkbox value: $value");
                          // Provider.of<_DailyInfoWidgetState>(context, listen: false).setState(() {
                          //   print("provider");
                          //   checkboxValues[index] = value!;
                          // });
                          setState(() {
                            print("setState");
                            checkboxValues[index] = value!;
                          });
                        },
                      ),
                    );
                  },
                ),
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.check),
          ),
        ),
      ),
    );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _bottomSheetBuilder(BuildContext context) {
    return SizedBox(
      height: 600,
      child: Center(
        child: Scaffold(
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchBar(
                  hintText: "Search",
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text("Test $index"),
                      trailing: Checkbox(
                        value: checkboxValues[index],
                        onChanged: (bool? value) {
                          print("Checkbox value: $value");
                          Provider.of<_DailyInfoWidgetState>(context, listen: false).setState(() {
                            print("provider");
                            checkboxValues[index] = value!;
                          });
                          setState(() {
                            print("setState");
                            checkboxValues[index] = value!;
                          });
                        },
                      ),
                    );
                  },
                ),
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.check),
          ),
        ),
      ),
    );
  }
}
