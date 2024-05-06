import 'package:chd_app/components/default_app_bar.dart';
import 'package:chd_app/models/info_entry_model.dart';
import 'package:chd_app/models/question_forum_model/question_forum_model.dart';
import 'package:chd_app/models/variable_entries_model.dart';
import 'package:chd_app/screens/data_entry_screen/personal_info.dart';
import 'package:chd_app/screens/login_screen.dart';
import 'package:chd_app/theme/theme_manager.dart';
import 'package:chd_app/utils/show_default_dialog.dart';
import 'package:flutter/material.dart';
import 'package:chd_app/screens/other_info_screen.dart';
import 'package:chd_app/screens/settings_screen.dart';
import 'package:chd_app/screens/user_search_screen.dart';
import 'package:provider/provider.dart';
import 'package:chd_app/main.dart';
import 'package:chd_app/theme/color_demo.dart';
import 'package:chd_app/screens/community_page.dart';

// Burger menu that can navigate to other pages
// ignore: use_key_in_widget_constructors
class BurgerMenu extends StatelessWidget {
  // A list of other pages for the app
  final List<Map<String, Function>> otherPages = [
    // Each page has a name and a widget
    {
      'Settings': (context) => Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Settings())) ///on tapped, Re-routes to settings page
    },
    {
      'Personal Information': (context) => Navigator.push(context, ///
          MaterialPageRoute(builder: (context) => const PersonalInfo())) ///on tapped, Re-routes to personal info page
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
      'User Search': (context) => Navigator.push(
          context, MaterialPageRoute(builder: (context) => const ShareScreen())) ///on tapped, Re-Routes to share screen
    },
    {
      'Other Info': (context) => Navigator.push(
          context, MaterialPageRoute(builder: (context) => const OtherInfo())) ///on tapped, Re-routes to 
    },
    {
      'Logout': (context) => showDefaultDialog(context,
              title: "Logout", ///on tapped, displays a popup that asks user if they're sure they want to logout?
              message: "Are you sure you want to logout?",
              actions: {
                "Yes": () async { ///if the user does, reset the models and display login screen 
                  await supabaseModel.signOut();
                  await Provider.of<InfoEntryModel>(context, listen: false)
                      .reset();
                  await Provider.of<VariableEntriesModel>(context,
                          listen: false)
                      .reset();
                  Provider.of<QuestionForumModel>(context, listen: false)
                      .reset();
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const Login()));
                },
                "No": () => Navigator.pop(context) ///if not, pop back to the burger menu
              })
    },
    {
      'Switch Theme': (context) { ///on tapped, switch theme
        bool isDark = 
            Provider.of<ThemeManager>(context, listen: false).themeMode ==
                ThemeMode.dark;///if the current theme of the app is lightmode, switch to darkMode (and vice versa)
        Provider.of<ThemeManager>(context, listen: false).toggleTheme(!isDark);
      }
    },
    {
      'Demo Theme (Dev only)': (context) {
        Navigator.push(context, ///on tapped, shows the colors of the theme 
            MaterialPageRoute(builder: (context) => const ColorDemo()));
      }
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
