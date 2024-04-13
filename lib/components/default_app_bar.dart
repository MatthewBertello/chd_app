import 'package:flutter/material.dart';

class DefaultAppBar extends AppBar {
  DefaultAppBar({Key? key, String? title})
      : super(
          key: key,
          title: Text(
            title ?? '',
          ),
        );
}
