import 'package:flutter/material.dart';
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
