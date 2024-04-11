import 'package:chd_app/components/default_app_bar.dart';
import 'package:chd_app/screens/login_screen.dart';
import 'package:chd_app/utils/show_default_dialog.dart';
import 'package:flutter/material.dart';
import 'package:chd_app/models/main_model.dart';
import 'package:chd_app/screens/other_info_screen.dart';
import 'package:chd_app/screens/settings_screen.dart';
import 'package:chd_app/screens/user_search_screen.dart';

// Burger menu that can navigate to other pages
// ignore: use_key_in_widget_constructors
class BurgerMenu extends StatelessWidget {
  // A list of other pages for the app
  final List<Map<String, Function>> otherPages = [
    // Each page has a name and a widget
    {
      'Settings': (context) => Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Settings()))
    },
    {
      'User Search': (context) => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ShareScreen(model: TestModel())))
    },
    {
      'Other Info': (context) => Navigator.push(
          context, MaterialPageRoute(builder: (context) => const OtherInfo()))
    },
    {
      'Logout': (context) => showDefaultDialog(context,
              title: "Logout",
              message: "Are you sure you want to logout?",
              actions: {
                "Yes": () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const Login()));
                },
                "No": () => Navigator.pop(context)
              })
    }
  ];

  // Builds a list of all the other pages that are clickable
  Widget buildBody(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(),
      itemCount: otherPages.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
            title: Text(otherPages[index].keys.first),
            onTap: () {
              otherPages[index].values.first(context);
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(),
      body: buildBody(context),
    );
  }
}
