import 'package:flutter/material.dart';
import 'package:chd_app/models/main_model.dart';
import 'package:chd_app/screens/other_info_screen.dart';
import 'package:chd_app/screens/settings_screen.dart';
import 'package:chd_app/screens/user_search_screen.dart';
import 'package:provider/provider.dart';

// Burger menu that can navigate to other pages
class BurgerMenu extends StatelessWidget {
  // A list of other pages for the app
  List<dynamic> otherPages = [["Settings",const Settings()], ["Find a member",ShareScreen(model: TestModel())], ["Resources",const OtherInfo()]];

  // Builds a list of all the other pages that are clickable
  Widget buildBody(BuildContext context) {
    return Expanded(
      child: ListView.separated(separatorBuilder:(context, index) => const Divider(),
      itemCount: otherPages.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(otherPages[index][0]), // Name of the page
          onTap: () {
            Navigator.push( // Navigate to the page once it's clicked
              context,
              MaterialPageRoute(builder: (context) => Consumer<TestModel> (
                builder: (context, model, child) {
                  return otherPages[index][1];
                }
              ))
            );
          }
        );
      },)
    );
  }
  
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(context)
    );
  }
}