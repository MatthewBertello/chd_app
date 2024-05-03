import 'package:chd_app/components/default_app_bar.dart';
import 'package:chd_app/models/info_entry_model.dart';
import 'package:chd_app/models/variable_entries_model.dart';
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
  bool loading = false;

  @override
  void initState() {
    // Initialize the model if it has not been loaded
    if (Provider.of<InfoEntryModel>(context, listen: false).loaded == false &&
        Provider.of<InfoEntryModel>(context, listen: false).loading == false) {
      Provider.of<InfoEntryModel>(context, listen: false).init();
    }
    Provider.of<InfoEntryModel>(context, listen: false).selectedDate =
        DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Get the list of variables that should be displayed
    var displayedVariables = Provider.of<InfoEntryModel>(context)
        .variableDefinitions
        .where((element) => element['checkbox'] == true)
        .toList();
    return Scaffold(
      appBar: DefaultAppBar(
        context: context,
        title: const Text('Info Entry'),
        actions: [_saveButton()],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                // Date picker for the entry
                child: DateTimeFormField(
                  initialValue:
                      Provider.of<InfoEntryModel>(context).selectedDate,
                  canClear: false,
                  lastDate: DateTime.now(),
                  onChanged: (DateTime? value) {
                    Provider.of<InfoEntryModel>(context, listen: false)
                        .selectedDate = value!;
                  },
                ),
              ),
              // List of displayed variables
              ListView.separated(
                shrinkWrap: true,
                itemCount: displayedVariables.length,
                itemBuilder: (context, index) {
                  // Display a list tile with the title, unit, and a form field
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
          // If the model is loading, display a loading animation
          loading || !Provider.of<InfoEntryModel>(context, listen: false).loaded
              ? Stack(
                  children: [
                    ModalBarrier(
                      color: Colors.black.withOpacity(0.3),
                      dismissible: false,
                    ),
                    Center(
                      child: LoadingAnimationWidget.fourRotatingDots(
                        color: Theme.of(context).colorScheme.primary,
                        size: 50,
                      ),
                    )
                  ],
                )
              : const SizedBox(),
        ],
      ),
      // The plus button to add a new variable
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var future = showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return const Wrap(children: [VariableSelectBottomSheet()]);
            },
          );
          future.then((value) => setState(() {}));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // The save button
  // When pressed, the model will submit the entry to the database
  Widget _saveButton() {
    return IconButton(
        onPressed: () {
          setState(() {
            loading = true;
          });
          final future =
              Provider.of<InfoEntryModel>(context, listen: false).submit();
          future.then((value) {
            Provider.of<VariableEntriesModel>(context, listen:false).init();
            setState(() {
              loading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Entry Added!'),
              ),
            );
          });
        },
        icon: const Icon(Icons.save),
        color: Theme.of(context).colorScheme.onPrimary);
  }

  // The loading animation
  Widget _loadingWidget() {
    if (loading || !Provider.of<InfoEntryModel>(context).loaded) {
      return const SizedBox();
    } else {
      return Stack(
        children: [
          ModalBarrier(
            color: Colors.black.withOpacity(0.3),
            dismissible: false,
          ),
          Expanded(
            child: Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                color: Theme.of(context).colorScheme.primary,
                size: 50,
              ),
            ),
          )
        ],
      );
    }
  }
}
