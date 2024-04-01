import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'member.dart';

class TestModel extends ChangeNotifier {
  String test = "hello";
  Connection? conn;

  // A method that searches a member depending on the keyword, 
  // TODO: will need to get it from database later
  List searchMember(String keyword) {
    return [Member(name: "Jan Doe", birthDate: DateTime(1990, 12, 3)), 
            Member(name: "John Doe", birthDate: DateTime(1970, 10, 4))];
  }

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
