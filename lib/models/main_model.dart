import 'package:flutter/material.dart';
import 'package:chd_app/main.dart';

class MainModel extends ChangeNotifier {
  String test = "hello";
  List membersSearched = [];

  List<Map<String, dynamic>>? variableDefinitions;

  Future<List<Map<String, dynamic>>?> getVariableDefinitions() async {
    final data = await supabase.from('variable_definitions').select();
    notifyListeners();
    return data;
  }

  // A method that searches a member depending on the keyword,
  Future<void> searchMember(String userID) async {
    clearMembersSearched(); // Clear the search list every time we're searching a new user
    final response = await supabase 
      .from('profiles')
      .select(); // Tried using .like after select, but it doesn't work... 

    // Add the member into the membersSearched list if the userID is similar to each member in the response
    for (var currentMember in response) {
      if (currentMember['id'].contains(userID)) {
        print(currentMember['id']);
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
