import 'package:flutter/material.dart';

Future<void> showDefaultDialog(BuildContext context, {required String title,
    required String message, required Map<String, Function> actions}) async {
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