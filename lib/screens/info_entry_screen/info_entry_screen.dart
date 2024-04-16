import 'package:chd_app/components/default_app_bar.dart';
import 'package:chd_app/models/info_entry_model.dart';
import 'package:chd_app/models/main_model.dart';
import 'package:chd_app/screens/info_entry_screen/variable_select_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:date_field/date_field.dart';

class DailyInfoWidget extends StatefulWidget {
  const DailyInfoWidget({super.key});

  @override
  State<DailyInfoWidget> createState() => _DailyInfoWidgetState();
}

class _DailyInfoWidgetState extends State<DailyInfoWidget> {
  @override
  void initState() {
    if (Provider.of<InfoEntryModel>(context, listen: false).loaded == false) {
      var variables = Provider.of<MainModel>(context, listen: false)
          .getVariableDefinitions();
      variables.then(
        (data) {
          Provider.of<InfoEntryModel>(context, listen: false)
              .setVariableDefinitions(data);
        },
      );
    }
    Provider.of<InfoEntryModel>(context, listen: false).selectedDate =
        DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var displayedVariables = Provider.of<InfoEntryModel>(context)
            .variableDefinitions
            ?.where((element) => element['checkbox'] == true)
            .toList() ??
        [];
    return Scaffold(
      appBar: DefaultAppBar(
        context: context,
        title: const Text('Info Entry'),
        actions: [
          IconButton(
              onPressed: () {
                setState(
                  () {
                    Provider.of<InfoEntryModel>(context, listen: false)
                        .submit();
                  },
                );
                ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Entry Added!'),
                      ),
                    );
              },
              icon: const Icon(Icons.save),
              color: Theme.of(context).colorScheme.onPrimary),
        ],
      ),
      body: !Provider.of<InfoEntryModel>(context).loaded
          ? Expanded(
              child: Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                  color: Theme.of(context).colorScheme.primary,
                  size: 50,
                ),
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DateTimeFormField(
                    initialValue:
                        Provider.of<InfoEntryModel>(context).selectedDate,
                    canClear: false,
                    lastDate: DateTime.now(),
                    onChanged: (DateTime? value) {
                      Provider.of<InfoEntryModel>(context, listen: false)
                          .selectedDate = value!;
                      print(value);
                    },
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  itemCount: displayedVariables.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(displayedVariables[index]['name'] ?? ""),
                      subtitle: Text(displayedVariables[index]['unit'] ?? ""),
                      trailing: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 100,
                          child: displayedVariables[index]['form'] ??
                              const Text("Error"),
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
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var future = showModalBottomSheet(
            context: context,
            // builder: _bottomSheetBuilder,
            builder: (BuildContext context) {
              return VariableSelectBottomSheet();
            },
          );
          future.then((value) => setState(() {}));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
