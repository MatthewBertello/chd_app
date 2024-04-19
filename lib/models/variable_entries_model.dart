import 'package:chd_app/main.dart';
import 'package:flutter/material.dart';

class VariableEntriesModel extends ChangeNotifier {
  bool loaded = false;
  bool loading = false;
  List<Map<String, dynamic>> variableDefinitions = [];
  List<Map<String, dynamic>> variableEntries = [];
  List<DateTime> dates = [];

  Future<dynamic> reset() async {
    while (loading) {
      continue;
    }
    variableDefinitions = [];
    variableEntries = [];
    dates = [];
    loaded = false;
  }

  Future<dynamic> init() async {
    while (loading) {
      continue;
    }
    loading = true;

    await getVariableDefinitions();
    await getVariableEntries();

    for (var entry in variableEntries) {
      var variable = variableDefinitions
          .firstWhere((element) => element['id'] == entry['variable_id']);
      entry['name'] = variable['name'];
      entry['unit'] = variable['unit'];
      entry['description'] = variable['description'];
      entry['date'] = DateTime.parse(entry['date']);
    }

    for (var entry in variableEntries) {
      DateTime entryDate = DateTime(entry['date'].year, entry['date'].month, entry['date'].day);
      if (!dates.contains(entryDate)) {
        dates.add(entryDate);
      }
    }
    
    dates.sort((a, b) => -a.compareTo(b));

    loaded = true;
    loading = false;
    notifyListeners();
  }

  Future<dynamic> getVariableDefinitions() async {
    try {
      variableDefinitions =
          await supabase.from('variable_definitions').select();
    } catch (e) {
      print(e);
    }
    variableDefinitions.sort((a, b) => a['name'].compareTo(b['name']));
  }

  Future<dynamic> getVariableEntries() async {
    try {
      variableEntries = await supabase
          .from('variable_entries')
          .select()
          .eq('user_id', supabase.auth.currentUser!.id);
    } catch (e) {
      print(e);
    }
  }

  List<Map<String, dynamic>> getVariableEntriesFromDate(
      {required DateTime date, required List<Map<String, dynamic>> entries}) {
    var filteredEntries = entries.where((element) {
      return element['date'].year == date.year &&
          element['date'].month == date.month &&
          element['date'].day == date.day;
    }).toList();

    return filteredEntries;
  }
}