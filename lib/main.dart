import 'package:flutter/material.dart';
import 'database_test.dart';
import 'test_model.dart';
import 'package:provider/provider.dart';


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
  int selectedIndex = 0;
  List<Widget> tabViews = [
    Consumer<TestModel>(
      builder: (context, model, child) {
        return DatabaseTest(model: model);
      },
    ),
    Consumer<TestModel>(
      builder: (context, model, child) {
        return Text('Page 2');
      },
    ),
    Consumer<TestModel>(
      builder: (context, model, child) {
        return Text('Page 3');
      },
    )
  ];

  void _handleTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: false),
      home: DefaultTabController(
        length: tabViews.length,
        child: Scaffold(
            bottomNavigationBar: BottomNavigationBar(
                currentIndex: selectedIndex,
                showUnselectedLabels: true,
                selectedItemColor: Colors.green,
                unselectedItemColor: Colors.blueAccent,
                backgroundColor: Colors.blue[200],
                onTap: _handleTap,
                items: const [
                  BottomNavigationBarItem(
                      label: 'Page 1', icon: Icon(Icons.question_mark)),
                  BottomNavigationBarItem(
                      label: 'Page 2', icon: Icon(Icons.add)),
                  BottomNavigationBarItem(
                      label: 'Page 3', icon: Icon(Icons.numbers))
                ]),
            body: tabViews[selectedIndex]),
      ),
    );
  }
}
