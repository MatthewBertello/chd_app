import 'package:flutter/material.dart';
import 'package:heart_safe/main.dart';
///Author: Grace Kiesau
///Date: 5/14/24
///Description: This is the file that allows the meter to change based on the rolling data entered
///Bugs: None Known
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
  
  ///sorts filters by dates and adds to new list when first encountered. upon next encounter, checks to see
  // if its in the defn. if it is, ignores. if not add.
  void filterFiles() {
   variableEntries.where((entry) {
     return entry['date'].isAfter(DateTime.now().subtract(Duration(days:7)));
    });
    variableEntries.sort((a, b) {
      return - a['date'].compareTo(b['date']);
    },);
    Set<String> foundEntries = {};
    var filtered = [];
     for(var entry in variableEntries){
      if (!foundEntries.contains(entry['name'])){
       filtered.add(entry);
       foundEntries.add(entry['name']);
      }
    }
  }
  
 //

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
