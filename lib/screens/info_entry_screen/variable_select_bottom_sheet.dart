import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VariableSelectBottomSheet extends StatefulWidget {
  const VariableSelectBottomSheet({super.key});

  @override
  State<VariableSelectBottomSheet> createState() =>
      _VariableSelectBottomSheetState();
}

class _VariableSelectBottomSheetState extends State<VariableSelectBottomSheet> {
  List<bool> checkboxValues = List.filled(10, false);

  @override
  Widget build(BuildContext context) {
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
                          setState(() {
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
