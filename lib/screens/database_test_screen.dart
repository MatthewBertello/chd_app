import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import '../models/main_model.dart';

class DatabaseTest extends StatefulWidget {
  const DatabaseTest({Key? key, required this.model}) : super(key: key);

  final TestModel model;

  @override
  State<DatabaseTest> createState() => _DatabaseTestState();
}

class _DatabaseTestState extends State<DatabaseTest> {
  @override
  void initState() {
    super.initState();
    setConnection();
  }

  Connection? conn;
  String result = '';

  void setConnection() {
    setState(() {
      conn = widget.model.conn;
    });
  } 

  void execute(String query) async {
    try {
      while (conn == null) {
        setConnection();
      }
      final results = await conn!.execute(query);
      setState(() {
        result = results.toString();
      });
    } catch (e) {
      setState(() {
        result = e.toString();
      });
    }
  }

  TextEditingController queryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: queryController,
              decoration: const InputDecoration(
                hintText: 'Query',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                execute(queryController.text);
              },
              child: const Text('Execute'),
            ),
            Text(result),
          ],
        ),
      ),
    );
  }
}
