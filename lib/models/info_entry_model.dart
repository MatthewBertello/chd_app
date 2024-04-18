import 'package:chd_app/main.dart';
import 'package:flutter/material.dart';

class InfoEntryModel extends ChangeNotifier {
  bool loaded = false;
  List<Map<String, dynamic>> variableDefinitions = [];
  Map<String, List<Map<String, dynamic>>> categorizedVariableDefinitions = {};
  DateTime selectedDate = DateTime.now();

  void getVariableDefinitions() async {
    // Load the variable definitions from the database
    variableDefinitions = await supabase.from('variable_definitions').select();
    variableDefinitions.sort((a, b) => a['name'].compareTo(b['name']));

    // Add checkbox, favorite, and form fields to each variable
    for (var element in variableDefinitions) {
      element['checkbox'] = false;
      element['favorite'] = false;
      element['form'] = TextFormField(
        controller: TextEditingController(),
        keyboardType: TextInputType.number,
      );
    }

    // Categorize the variables
    for (var element in variableDefinitions) {
      if (!categorizedVariableDefinitions.containsKey(element['category'])) {
        categorizedVariableDefinitions[element['category']] = [];
      }
      categorizedVariableDefinitions[element['category']]!.add(element);
    }

    loaded = true;
    notifyListeners();
  }

  void submit() {
    for (var element in variableDefinitions) {
      element['checkbox'] = element['favorite'];
      element['form'].controller!.clear();
    }
    selectedDate = DateTime.now();
    notifyListeners();
  }
}
