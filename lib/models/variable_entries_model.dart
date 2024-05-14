import 'package:heart_safe/main.dart';
import 'package:flutter/material.dart';

class VariableEntriesModel extends ChangeNotifier {
  bool loaded = false;
  bool loading = false;
  List<Map<String, dynamic>> variableDefinitions = [];
  List<Map<String, dynamic>> variableEntries = [];
  List<DateTime> dates = [];

  // Reset the model
  // This should be called when the user logs out
  Future<dynamic> reset() async {
    while (loading) {
      continue;
    }
    variableDefinitions = [];
    variableEntries = [];
    dates = [];
    loaded = false;
  }

  // Initialize the model
  Future<dynamic> init() async {
    // If this model is already loading, wait for it to finish
    while (loading) {
      continue;
    }
    loading = true;

    // Get the variable definitions and entries
    await getVariableDefinitions();
    await getVariableEntries();

    // Add name, unit, and description to each entry
    for (var entry in variableEntries) {
      var variable = variableDefinitions
          .firstWhere((element) => element['id'] == entry['variable_id']);
      entry['name'] = variable['name'];
      entry['unit'] = variable['unit'];
      entry['description'] = variable['description'];
      entry['date'] = DateTime.parse(entry['date']);
    }

    // Get the unique dates of the entries
    for (var entry in variableEntries) {
      DateTime entryDate =
          DateTime(entry['date'].year, entry['date'].month, entry['date'].day);
      if (!dates.contains(entryDate)) {
        dates.add(entryDate);
      }
    }

    dates.sort((a, b) => -a.compareTo(b));

    loaded = true;
    loading = false;
    notifyListeners();
  }

  // Get the variable definitions from the supabaseModel
  Future<dynamic> getVariableDefinitions() async {
    variableDefinitions = await supabaseModel.getVariableDefinitions();
    variableDefinitions.sort((a, b) => a['name'].compareTo(b['name']));
  }

  // Get the variable entries from the supabaseModel
  Future<dynamic> getVariableEntries() async {
    variableEntries = await supabaseModel.getVariableEntries();
  }

  // Get the variable entries from a specific date
  List<Map<String, dynamic>> getVariableEntriesFromDate(
      {required DateTime date, required List<Map<String, dynamic>> entries}) {
    var filteredEntries = entries.where((element) {
      return element['date'].year == date.year &&
          element['date'].month == date.month &&
          element['date'].day == date.day;
    }).toList();

    return filteredEntries;
  }

  // Get the variable entries by the variable id
  List<Map<String, dynamic>> getVariableEntriesById(
      {required int id, required List<Map<String, dynamic>> entries}) {
    var filteredEntries = entries.where((element) {
      return element['variable_id'] == id;
    }).toList();

    return filteredEntries;
  }
}
