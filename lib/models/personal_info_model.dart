// ignore_for_file: avoid_print, unused_local_variable

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:heart_safe/main.dart';

///Author: Pachia Lee, Grace Kiesau, Matthew Bertello
///Date: 5/14/24
///Description: allows user to enter one time data into the db
///Bugs: None Known
class PersonalInfoModel extends ChangeNotifier {
  bool loaded = false;
  bool loading = false;
  DateTime selectedDate = DateTime.now();

  dynamic userInfo = {};
  Map<String, dynamic> userInfoMap = {};
  List<dynamic> personalInfoVariables = [];
  Map<String, dynamic> variables = {};
  final List<String> notEnumTypes = ['text', 'date', 'int'];

  Future<dynamic> reset() async {
    while (loading) {
      continue;
    }
    // Make sure all variables are set back to default
    userInfo = {};
    personalInfoVariables = [];
    variables = {};
    loaded = false;
  }

  Future<dynamic> init() async {
    while (loading) {
      continue;
    }
    loading = true;

    await getUserInfo();
    await getPersonalInfoVariables();
    await prepareUserInfoVariables();
    addForms();

    loaded = true;
    loading = false;
    notifyListeners();
  }

  Future<dynamic> getUserInfo() async {
    userInfo = await supabaseModel.getUserInfo();
  }

  Future<dynamic> updateUsername(String username) async {
    final response = await supabaseModel.supabase!
      .from('user_info')
      .update({'user_name': username})
      .eq('user_id', supabaseModel.supabase!.auth.currentUser!.id);

    print(response);
      notifyListeners();
  }

  Future<dynamic> getPersonalInfoVariables() async {
    personalInfoVariables = await supabaseModel.getPersonalInfoVariables();
    for (var row in personalInfoVariables) {
      var name = row['name'];
      row.remove(row['name']);
      row['key'] = name;
      variables[name] = row;
    }
  }

  Future<dynamic> getEnumValues(String enumName) async {
    final oidQuery = await supabaseModel.supabase!
        .from('public_pg_type')
        .select('oid')
        .eq('typname', enumName);
    var oid = oidQuery[0]['oid'];

    final valuesQuery = await supabaseModel.supabase!
        .from('public_pg_enum')
        .select('enumlabel, enumsortorder')
        .eq('enumtypid', oid);
    List<dynamic> values = [];
    for (var value in valuesQuery) {
      values.add({
        'enumlabel': value['enumlabel'],
        'enumsortorder': value['enumsortorder']
      });
    }
    return values;
  }

  Future<dynamic> prepareUserInfoVariables() async {
    for (var key in variables.keys) {
      if (userInfo.containsKey(key)) {
        variables[key]!['value'] = userInfo[key];
        variables[key]!['title'] = cleanTitle(key);
        if (!notEnumTypes.contains(variables[key]!['unit'])) {
          variables[key]!['values'] =
              await getEnumValues(variables[key]!['unit']);
          variables[key]!['values'].sort((a, b) {
            if (a['enumsortorder'].toInt() > b['enumsortorder'].toInt()) {
              return 1;
            } else if (a['enumsortorder'].toInt() <
                b['enumsortorder'].toInt()) {
              return -1;
            }
            return 0;
          });
        } else {
          variables[key]!['values'] = variables[key]!['unit'];
        }
      } else {
        variables.remove(key);
      }
    }
  }

  void addForms() {
    for (var key in variables.keys) {
      if (!notEnumTypes.contains(variables[key]!['unit'])) {
      } else if (variables[key]!['unit'] == 'int') {
        var numField = TextFormField(
          keyboardType: TextInputType.number,
          controller: TextEditingController(text: variables[key]!['value']?.toString()),
          minLines: 1,
          maxLines: 10,
          maxLength: 1000,
        );
        variables[key]!['input'] = numField;
      } else if (variables[key]!['unit'] == 'date') {
        var dateTimeField = DateTimeFormField(
          mode: DateTimeFieldPickerMode.date,
          initialValue: variables[key]!['value'] != null
              ? DateTime.parse(variables[key]!['value'])
              : null,
          onChanged: (DateTime? value) {
            saveSelectedToDb(variables[key]!['key'], value?.toIso8601String());
          },
        );
        variables[key]!['input'] = dateTimeField;
      } else {
        var textField = createTextFormField(variables[key]!['value']);
        variables[key]!['input'] = textField;
      }
    }
  }

  // Cleans the column name from the database for the title of a variable
  String cleanTitle(String clutteredTitle) {
    var splitTitle = clutteredTitle.split('_');
    String title = "";

    for (var word in splitTitle) {
      // If the work is Num change it to #
      if (word == "num") {
        word = "#";
      } else {
        // Get the first letter and capitalize it
        String firstLetter = word[0].toUpperCase();
        word = firstLetter + word.substring(1);
      }

      title += "$word "; // Add the word to the title
    }

    return title;
  }

  TextFormField createTextFormField(String? initialValue) {
    return TextFormField(
      controller: TextEditingController(text: initialValue),
      minLines: 1,
      maxLines: 10,
      maxLength: 1000,
    );
  }

  Future<dynamic> saveSelectedToDb(String variable, String? value) async {
    try {
      await supabaseModel.supabase!
          .from('user_info')
          .update({variable: value}).match(
              {'user_id': supabaseModel.supabase!.auth.currentUser!.id});

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
