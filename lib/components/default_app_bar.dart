import 'package:flutter/material.dart';

class DefaultAppBar extends AppBar {
  DefaultAppBar({Key? key, Widget? title, required BuildContext context})
      : super(
          key: key,
          title: title,
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
