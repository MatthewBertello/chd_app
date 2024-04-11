import 'package:flutter/material.dart';

Future<void> showDefaultDialog(BuildContext context, String title,
    String message, Map<String, Function> actions) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: actions.entries.map((entry) {
          return TextButton(
            onPressed: () {
              entry.value();
            },
            child: Text(entry.key),
          );
        }).toList(),
      );
    },
  );
}
