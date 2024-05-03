import 'package:chd_app/components/default_app_bar.dart';
import 'package:chd_app/models/info_entry_model.dart';
import 'package:chd_app/models/variable_entries_model.dart';
import 'package:chd_app/screens/data_entry_screen/data_entry_dropdown.dart';
import 'package:chd_app/screens/data_entry_screen/physical_data_entry.dart';
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
import 'package:chd_app/screens/data_entry_screen/demographic_data_entry.dart';

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
      'Personal Information': (context) => Navigator.push(
          context, MaterialPageRoute(builder: (context) => const DataDropdown()))
    },
    {
      'Question Forum': (context) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const CommunityPage())); //On clicked, Re-routes to Online discussion forum
      }
    },
    {
      'User Search': (context) => Navigator.push(
          context, MaterialPageRoute(builder: (context) => const ShareScreen()))
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
                "Yes": () async {
                  await supabaseModel.signOut();
                  await Provider.of<InfoEntryModel>(context, listen: false).reset();
                  await Provider.of<VariableEntriesModel>(context, listen: false).reset();
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const Login()));
                },
                "No": () => Navigator.pop(context)
              })
    },
    {
      'Switch Theme': (context) {
        bool isDark =
            Provider.of<ThemeManager>(context, listen: false).themeMode ==
                ThemeMode.dark;
        Provider.of<ThemeManager>(context, listen: false).toggleTheme(!isDark);
      }
    },
    {
      'Demo Theme (Dev only)': (context) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ColorDemo()));
      }
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
