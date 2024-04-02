import 'package:chd_app/test_model.dart';
import 'package:flutter/material.dart';
import 'shareScreen.dart';
import 'package:provider/provider.dart';

class Overview extends StatelessWidget {
  const Overview({required this.model});
  final TestModel model;

  // Makes the search button and navigates to shareScreen when pressed
  IconButton buildSearchButton(BuildContext context) {
    return IconButton(
              onPressed: () {
                  model.clearMembersSearched();
                  Navigator.push(
                    context,
                    MaterialPageRoute( // Navigates to shareScreen
                        builder: (context) => Consumer<TestModel> (
      builder: (context, model, child) {
        return ShareScreen(model: model);
      })));
                
              },
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ));
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
        flexibleSpace: Container(
            decoration: BoxDecoration(
                // Gives the app bar a gradient red color
                gradient: LinearGradient(colors: <Color>[
          const Color.fromARGB(255, 249, 0, 0).withOpacity(0.9),
          const Color.fromARGB(223, 189, 0, 0).withOpacity(0.9)
        ]))),
        toolbarHeight: 100,
        actions: [
          buildSearchButton(context)
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: buildAppBar(context));
  }
}
