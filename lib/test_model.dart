import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

class TestModel extends ChangeNotifier {
  String test = "hello";
  Connection? conn;

  TestModel() {
    Future<dynamic> newConn = Connection.open(
      Endpoint(
        port: 26257,
        host: 'wool-toucan-14257.5xj.gcp-us-central1.cockroachlabs.cloud',
        database: 'chd_app',
        username: 'chd_app',
        password: '5mBo9-e559vGXyBc_rVCMA',
      ),
      settings: const ConnectionSettings(sslMode: SslMode.verifyFull),
    );
    newConn.then((connection) => conn = connection);
  }
}
