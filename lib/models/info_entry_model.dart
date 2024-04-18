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

  Future<dynamic> submit() async {
    for (var element in variableDefinitions) {
      if (element['checkbox'] && element['form'].controller!.text.isNotEmpty) {
        try {
          print('Entering data ${element['name']}');
          await supabase.from('variable_entries').insert([
            {
              'user_id': supabase.auth.currentUser!.id,
              'variable_id': element['id'],
              'value': double.tryParse(element['form'].controller!.text),
              'date': selectedDate.toIso8601String(),
            }
          ]);
        } catch (e) {
          print('Error entering data ${element['name']}');
          print(e);
        }
      }
      element['checkbox'] = element['favorite'];
      element['form'].controller!.clear();
    }
    selectedDate = DateTime.now();
    notifyListeners();
  }
}
