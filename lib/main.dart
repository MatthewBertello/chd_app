import 'package:chd_app/login.dart';
import 'package:chd_app/signUp.dart';
import 'package:flutter/material.dart';
import 'test_model.dart';
import 'package:provider/provider.dart';
import 'overview.dart';
import 'healthMonitering.dart';
import 'dailyInfo.dart';
import 'otherInfo.dart';
import 'oneTimeInfo.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => TestModel(),
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userLoggedIn =
      false; // CHANGE IT TO TRUE TO VIEW TABBED BAR WHEN USER IS LOGGED IN
  int selectedIndex = 0;
  int pageIndex = 0;

  List<Widget> tabViews = [
    Consumer<TestModel>(
      builder: (context, model, child) {
        return Overview(model: model);
      },
    ),
    Consumer<TestModel>(
      builder: (context, model, child) {
        return HealthWidget(
            model: model); // TODO: Call healthmonitering's constructor
      },
    ),
    Consumer<TestModel>(
      builder: (context, model, child) {
        return DailyInfoWidget(); // TODO: Call dailyInfo's constructor
      },
    ),
    Consumer<TestModel>(builder: (context, model, child) {
      return OtherInfo(); // TODO: Call OtherInfo's constructor
    })
  ];

  void updatePage(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  void _handleTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return Login(updatePage: updatePage);
        break;
      case 1:
        return displayWithNavBar(context);
        break;
      case 2:
        return SignUpScreen(updatePage: updatePage);
        break;
      case 3:
        return SubstantialEntry(updatePage: updatePage);
        break;
      default:
        return displayWithNavBar(context);
    }
  }

  // If user is logged in display screens with bottom navigation bar
  Widget displayWithNavBar(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: selectedIndex,
            showUnselectedLabels: true,
            selectedItemColor: Colors.red[600],
            unselectedItemColor: Colors.indigo[900],
            backgroundColor: Colors.blue[200],
            onTap: _handleTap,
            items: const [
              BottomNavigationBarItem(
                  label: 'Overview', icon: Icon(Icons.dashboard)),
              BottomNavigationBarItem(
                  label: 'Health', icon: Icon(Icons.favorite)),
              BottomNavigationBarItem(
                  label: 'Daily Entry', icon: Icon(Icons.notes)),
              BottomNavigationBarItem(
                  label: 'Resources', icon: Icon(Icons.question_mark)),
            ]),
        body: tabViews[selectedIndex]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
          length: tabViews.length,
          // If the user is logged in, display overview with tabbed navigation, otherwise display the launchscreen
          child: _getPage(pageIndex)),
    );
  }
}
