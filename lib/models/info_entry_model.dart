import 'package:flutter/material.dart';

class InfoEntryModel extends ChangeNotifier {
  bool loaded = false;
  List<Map<String, dynamic>> variableDefinitions = [];
  DateTime selectedDate = DateTime.now();

  void setVariableDefinitions(List<Map<String, dynamic>>? definitions) {
    variableDefinitions = definitions ?? [];
    loaded = true;
    for (var element in variableDefinitions) {
      element['checkbox'] = false;
      element['favorite'] = false;
      element['form'] = TextFormField(
        controller: TextEditingController(),
        keyboardType: TextInputType.number,
      );
    }
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

  void setCheckbox(int index, bool value) {
    variableDefinitions[index]['checkbox'] = value;
    notifyListeners();
  }

  void setFavorite(int index, bool value) {
    variableDefinitions[index]['favorite'] = value;
    notifyListeners();
  }
}
