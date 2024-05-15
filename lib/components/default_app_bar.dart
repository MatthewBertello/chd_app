import 'package:flutter/material.dart';
///Author: Matthew Bertello
///Date: 5/14/24
///Description: This is the file that allows the meter to change based on the rolling data entered
///Bugs: None Known

///Appbar used for all files. This gives the app a streamlined feel across all screens
class DefaultAppBar extends AppBar { 
  DefaultAppBar({Key? key, Widget? title, required BuildContext context, List<Widget>? actions})
      : super(
          key: key,
          title: title,
          actions: actions,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.primary,
                ],
              ),
            )
          ),
        );
}
