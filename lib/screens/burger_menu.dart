import 'package:heart_safe/components/default_app_bar.dart';
import 'package:heart_safe/models/info_entry_model.dart';
import 'package:heart_safe/models/meter_model.dart';
import 'package:heart_safe/models/personal_info_model.dart';
import 'package:heart_safe/models/question_forum_model/question_forum_model.dart';
import 'package:heart_safe/models/supabase_model.dart';
import 'package:heart_safe/models/variable_entries_model.dart';
import 'package:heart_safe/screens/personal_info.dart';
import 'package:heart_safe/screens/login_screen.dart';
import 'package:heart_safe/utils/show_default_dialog.dart';
import 'package:flutter/material.dart';
import 'package:heart_safe/screens/other_info_screen.dart';
import 'package:heart_safe/screens/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:heart_safe/main.dart';
import 'package:heart_safe/screens/community_page.dart';

///Author: Pachia Lee, Grace Kiesau
///Date: 5/14/24
///Description: displays links to other featuers in the app for easy nav
///Bugs: None Known
///reflection: pretty straightforward

// Burger menu that can navigate to other pages
// ignore: use_key_in_widget_constructors
class BurgerMenu extends StatelessWidget {
  // A list of other pages for the app
  final List<Map<String, Function>> otherPages = [
    // Each page has a name and a widget
    {
      'Settings': (context) => Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Settings()))

      ///on tapped, Re-routes to settings page
    },
    {
      'Personal Information': (context) => Navigator.push(
          context,

          ///
          MaterialPageRoute(builder: (context) => const PersonalInfo()))

      ///on tapped, Re-routes to personal info page
    },
    {
      'Question Forum': (context) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const CommunityPage())); //On tapped, Re-routes to Online discussion forum
      }
    },
    {
      'Resources': (context) => Navigator.push(
          context, MaterialPageRoute(builder: (context) => const OtherInfo()))

      ///on tapped, Re-routes to
    },
    {
      'Logout': (context) => showDefaultDialog(context,
              title: "Logout",

              ///on tapped, displays a popup that asks user if they're sure they want to logout?
              message: "Are you sure you want to logout?",
              actions: {
                "Yes": () async {
                  ///if the user does, reset the models and display login screen
                  await supabaseModel.signOut();
                  await Provider.of<InfoEntryModel>(context, listen: false)
                      .reset();
                  await Provider.of<VariableEntriesModel>(context, listen: false).reset();
                  await Provider.of<MeterModel>(context, listen: false)
                      .reset();
                  await Provider.of<PersonalInfoModel>(context, listen: false)
                      .reset();
                  Provider.of<QuestionForumModel>(context, listen: false)
                      .reset();
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const Login()));
                },
                "No": () => Navigator.pop(context)

                ///if not, pop back to the burger menu
              })
    }
  ];

  // Builds a list of all the pages in the menu that are clickable
  Widget buildBody(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(),
      itemCount: otherPages.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(otherPages[index].keys.first),
          onTap: () {
            otherPages[index].values.first(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(context: context),
      body: buildBody(context),
    );
  }
}
