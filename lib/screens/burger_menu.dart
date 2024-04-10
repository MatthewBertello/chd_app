import 'package:flutter/material.dart';
import 'package:chd_app/models/main_model.dart';
import 'package:chd_app/screens/other_info_screen.dart';
import 'package:chd_app/screens/settings_screen.dart';
import 'package:chd_app/screens/user_search_screen.dart';
import 'package:provider/provider.dart';

class BurgerMenu extends StatelessWidget {
  // A list of other pages for the app
  List<dynamic> otherPages = [["Settings",const Settings()], ["Find a member",ShareScreen(model: TestModel())], ["Resources",const OtherInfo()]];

  Widget buildBody(BuildContext context) {
    return Expanded(
      child: ListView.separated(separatorBuilder:(context, index) => Divider(),
      itemCount: otherPages.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(otherPages[index][0]),
          onTap: () {
            Navigator.push(
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