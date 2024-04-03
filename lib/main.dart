import 'package:chd_app/launch.dart';
import 'package:chd_app/settings.dart';
import 'package:flutter/material.dart';
import 'database_test.dart';
import 'test_model.dart';
import 'package:provider/provider.dart';
import 'overview.dart';
import 'healthMonitering.dart';
import 'dailyInfo.dart';
import 'launch.dart';
import 'otherInfo.dart';


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
  bool userLoggedIn = false; // CHANGE IT TO TRUE TO VIEW TABBED BAR WHEN USER IS LOGGED IN
  int selectedIndex = 0;
  
  List<Widget> tabViews = [
    Consumer<TestModel>(
      builder: (context, model, child) {
        return Overview(model: model); 
      },
    ),
    Consumer<TestModel>(
      builder: (context, model, child) {
        return HealthWidget(model: model); // TODO: Call healthmonitering's constructor
      },
    ),
    Consumer<TestModel>(
      builder: (context, model, child) {
        return DailyInfoWidget(); // TODO: Call dailyInfo's constructor
      },
    ),
    Consumer<TestModel> ( 
      builder: (context, model, child) {
        return OtherInfo(); // TODO: Call OtherInfo's constructor
      }
    )
  ];

  void _handleTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  // If user is not logged in, display launch screen
  Widget displayLaunchScreen (BuildContext context) {
    return const LaunchScreen(); 
  }

  // If user is logged in display screens with bottom navigation bar
  Widget displayWithNavBar (BuildContext context) {
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
        child: (userLoggedIn) ? displayWithNavBar(context): displayLaunchScreen(context)
      ),
    );
  }
}
