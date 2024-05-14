import 'package:flutter/material.dart';
import 'package:chd_app/models/main_model.dart';
import 'package:provider/provider.dart';
import 'package:chd_app/screens/overview_screen.dart';
import 'package:chd_app/screens/health_screen.dart';
import 'package:chd_app/screens/info_entry_screen/info_entry_screen.dart';
import 'package:chd_app/screens/burger_menu.dart';
///Author: Grace Kiesau
///Date: 5/14/24
///Description: This is the file that allows the meter to change based on the rolling data entered
///Bugs: None Known

///this is the navigation bar used across the app. Allows for easy navigation between pages we anticipate the 
///user will use most often
class TabView extends StatelessWidget {
  final List<Tab> tabs = [
    const Tab(icon: Icon(Icons.dashboard)), ///displays the users health, pregnancy progress, and recomendations
    const Tab(icon: Icon(Icons.favorite)), ///displays the variables user is most concerned about tracking
    const Tab(icon: Icon(Icons.notes)), ///displays the users health and gives the past entries
    const Tab(icon: Icon(Icons.menu)), ///displays menu with other features of the app (settings, forum, etc..)
  ];
  final List<Widget> children = [
    Consumer<MainModel>(
      builder: (context, model, child) {
        return Overview(model: model);
      },
    ),
    Consumer<MainModel>(
      builder: (context, model, child) {
        return HealthWidget(model: model);
      },
    ),
    const DailyInfoWidget(),
    BurgerMenu(),
  ];

  TabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(  ///this builds the navigation bar
      color: Theme.of(context).colorScheme.background,
      child: SafeArea(
        top: false, 
        child: DefaultTabController( 
          length: tabs.length,
          child: Scaffold(
              body: TabBarView(
                children: children,
              ),
              bottomNavigationBar: TabBar(
                tabs: tabs,
              )),
        ),
      ),
    );
  }
}
