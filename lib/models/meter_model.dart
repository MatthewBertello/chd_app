import 'package:flutter/material.dart';
import 'package:heart_safe/main.dart';

enum Status { low, high, target, na }

///Author: Grace Kiesau
///Date: 5/14/24
///Description: This is the file that allows the meter to change based on the rolling data entered
///Bugs: None Known
///reflection: overall this was pretty straightforward
class MeterModel extends ChangeNotifier {
  bool loaded = false;
  bool loading = false;
  List<dynamic> variableDefinitions = [];
  List<dynamic> variableEntries = [];
  List<dynamic> variableEntriesFiltered = [];
  List<DateTime> dates = [];
  Map<String, Map<Status, int>> statusCount = {};
  List<dynamic> outOfRangeVars = [];

  // Reset the model
  // This should be called when the user logs out
  Future<dynamic> reset() async {
    while (loading) {
      continue;
    }
    outOfRangeVars = [];
    variableDefinitions = [];
    variableEntries = [];
    variableEntriesFiltered = [];
    statusCount = {};
    outOfRangeVars = [];
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

    outOfRangeVars = [];
    variableDefinitions = [];
    variableEntries = [];
    variableEntriesFiltered = [];
    statusCount = {};
    outOfRangeVars = [];
    dates = [];

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
      entry['lower_goal_limit'] = variable['lower_goal_limit'];
      entry['upper_goal_limit'] = variable['upper_goal_limit'];
      entry['target_goal_limit'] = variable['target_goal_limit'];
      entry['category'] = variable['category'];
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

    variableEntriesFiltered = [];
    statusCount = {};
    processFilteredVariableEntries();
    setOutOfRangeVariables();

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
  List<dynamic> getVariableEntriesFromDate(
      {required DateTime date, required List<dynamic> entries}) {
    var filteredEntries = entries.where((element) {
      return element['date'].year == date.year &&
          element['date'].month == date.month &&
          element['date'].day == date.day;
    }).toList();

    return filteredEntries;
  }

  // Get the variable entries by the variable id
  List<dynamic> getVariableEntriesById(
      {required int id, required List<dynamic> entries}) {
    var filteredEntries = entries.where((element) {
      return element['variable_id'] == id;
    }).toList();

    return filteredEntries;
  }

  ///sorts filters by dates and adds to new list when first encountered. upon next encounter, checks to see
  // if its in the defn. if it is, ignores. if not add.
  void processFilteredVariableEntries() {
    variableEntries.where((entry) {
      return entry['date'].isAfter(DateTime.now().subtract(const Duration(days: 7)));
    });
    variableEntries.sort(
      (a, b) {
        return -a['date'].compareTo(b['date']);
      },
    );
    Set<String> foundEntries = {};
    for (var entry in variableEntries) {
      if (!foundEntries.contains(entry['name'])) {
        variableEntriesFiltered.add(entry);
        foundEntries.add(entry['name']);
      }
    }

    for (var entry in variableEntriesFiltered) {
      if (entry['lower_goal_limit'] != null) {
        if (entry['value'] < entry['lower_goal_limit']) {
          entry['status'] = Status.low;
        }
      } else if (entry['upper_goal_limit'] != null) {
        if (entry['value'] > entry['upper_goal_limit']) {
          entry['status'] = Status.high;
        }
      }
      if (entry['lower_goal_limit'] != null ||
          entry['upper_goal_limit'] != null) {
        if (entry['status'] == null) {
          entry['status'] = Status.target;
        }
      } else {
        entry['status'] = Status.na;
      }
    }
// {"category": "Physical", "status": "low"} - entry
// {"Physical" : {low: 1, high: 0}} - statusCount
    for (var entry in variableEntriesFiltered) {
      var category = entry['category'];
      if (statusCount[category] == null) {
        statusCount[category] = {
          Status.low: 0,
          Status.high: 0,
          Status.target: 0,
          Status.na: 0,
        };
        statusCount[category]![entry['status']] =
            statusCount[category]![entry['status']]! + 1;
      } else {
        statusCount[category]![entry['status']] =
            statusCount[category]![entry['status']]! + 1;
      }
    }
  }

  double getTotalStatusPercentage() {
    double total = 0;
    double failed = 0;
    for (var category in statusCount.keys) {
      for (var status in statusCount[category]!.keys) {
        if (status == Status.low || status == Status.high) {
          failed += statusCount[category]![status]!;
          total += statusCount[category]![status]!;
        } else if (status == Status.target) {
          total += statusCount[category]![status]!;
        }
      }
    }
    total = total == 0 ? 1 : total;
    var percentage = (total - failed) / total;
    return percentage;
  }

  double getCategoryStatusPercentage({required String category}) {
    double total = 0;
    double failed = 0;
    for (var status in statusCount[category]!.keys) {
      if (status == Status.low || status == Status.high) {
        failed += statusCount[category]![status]!;
        total += statusCount[category]![status]!;
      } else if (status == Status.target) {
        total += statusCount[category]![status]!;
      }
    }
    total = total == 0 ? 1 : total;
    var percentage = (total - failed) / total;
    return percentage;
  }

  void setOutOfRangeVariables() {
    for(var variable in variableEntriesFiltered) {
      if(variable['status'] == Status.low || variable['status'] == Status.high) {
        var varInfo = {"name": variable['name'], "description": variable['description']};
        outOfRangeVars.add(varInfo);
      }
    }
  }
}
