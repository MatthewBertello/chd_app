import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

class DatabaseTest extends StatefulWidget {
  const DatabaseTest({Key? key}) : super(key: key);

  @override
  State <DatabaseTest> createState() => _DatabaseTestState();
}

class _DatabaseTestState extends State<DatabaseTest> {

  @override
  void initState() {
    super.initState();
    setConnection();
  }
  late final Connection conn;
  String result = '';

  void execute(String query) async {
    try {
      final results = await conn.execute(query);
      setState(() {
        result = results.toString();
      });
    } catch (e) {
      setState(() {
        result = e.toString();
      });
    }
  }


  void setConnection() async {
    final newConn = await Connection.open(
      Endpoint(
        port: 26257,
        host: 'wool-toucan-14257.5xj.gcp-us-central1.cockroachlabs.cloud',
        database: 'chd_app',
        username: 'chd_app',
        password: '5mBo9-e559vGXyBc_rVCMA',
      ),
      settings: const ConnectionSettings(sslMode: SslMode.verifyFull),
    );

    setState(() {
      conn = newConn;
    });
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
