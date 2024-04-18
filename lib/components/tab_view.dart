import 'package:flutter/material.dart';
import 'package:chd_app/models/main_model.dart';
import 'package:provider/provider.dart';
import 'package:chd_app/screens/overview_screen.dart';
import 'package:chd_app/screens/health_screen.dart';
import 'package:chd_app/screens/info_entry_screen/info_entry_screen.dart';
import 'package:chd_app/screens/burger_menu.dart';

class TabView extends StatelessWidget {
  final List<Tab> tabs = [
    const Tab(icon: Icon(Icons.dashboard)),
    const Tab(icon: Icon(Icons.favorite)),
    const Tab(icon: Icon(Icons.notes)),
    const Tab(icon: Icon(Icons.menu)),
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
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
          body: TabBarView(
            children: children,
          ),
          bottomNavigationBar: TabBar(
            tabs: tabs,
          )),
    );
  }
}
