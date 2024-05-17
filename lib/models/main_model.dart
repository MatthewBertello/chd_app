import 'package:flutter/material.dart';
import 'package:heart_safe/main.dart';

///Author: 
///Date: 5/14/24
///Description: This is the file that allows the meter to change based on the rolling data entered
///Bugs: None Known
///reflection: not in use
class MainModel extends ChangeNotifier {
  String test = "hello";
  List membersSearched = [];

  List<dynamic>? variableDefinitions;

  Future<List<dynamic>?> getVariableDefinitions() async {
    final data = await supabaseModel.supabase!.from('variable_definitions').select();
    notifyListeners();
    return data;
  }

  // A method that searches a member depending on the keyword,
  Future<void> searchMember(String userID) async {
    clearMembersSearched(); // Clear the search list every time we're searching a new user
    final response = await supabaseModel.supabase! 
      .from('profiles')
      .select(); // Tried using .like after select, but it doesn't work... 

    // Add the member into the membersSearched list if the userID is similar to each member in the response
    for (var currentMember in response) {
      if (currentMember['id'].contains(userID)) {
        membersSearched.add(currentMember['id']);
      }
    }

    notifyListeners();
  }

  // Clears all the members in the membersSearched list
  clearMembersSearched() {
    membersSearched = [];
  }
}
