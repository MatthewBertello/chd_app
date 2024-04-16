import 'package:flutter/material.dart';

class InfoEntryModel extends ChangeNotifier {
  bool loaded = false;
  List<Map<String, dynamic>>? variableDefinitions;
  DateTime selectedDate = DateTime.now();

  void setVariableDefinitions(List<Map<String, dynamic>>? definitions) {
    variableDefinitions = definitions;
    loaded = true;
    if (variableDefinitions != null) {
      for (var element in variableDefinitions!) {
        element['checkbox'] = false;
        element['favorite'] = false;
        element['form'] = TextFormField(
          keyboardType: TextInputType.number,
        );
      }
    }
    notifyListeners();
  }

  void submit() {
    print('Submit');
    for (var element in variableDefinitions!) {
      element['checkbox'] = element['favorite'];
      element['form'] = TextFormField(
        keyboardType: TextInputType.number,
      );
    }
    selectedDate = DateTime.now();
  }

  void setCheckbox(int index, bool value) {
    variableDefinitions![index]['checkbox'] = value;
    notifyListeners();
  }

  void setFavorite(int index, bool value) {
    variableDefinitions![index]['favorite'] = value;
    notifyListeners();
  }
}
