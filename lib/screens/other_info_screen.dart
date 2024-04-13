import 'package:chd_app/components/default_app_bar.dart';
import 'package:flutter/material.dart';

class OtherInfo extends StatelessWidget {
  const OtherInfo({super.key});

  final String bullet = "\u2022 ";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: DefaultAppBar(context: context, title: 'More Info'),
        body: Padding(
            padding: const EdgeInsets.only(right: 20.0, left: 20.0, top: 8.0),
            child: Column(
              children: [
                // the box containing the information (can be copy and pasted)
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all()),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Align(
                              alignment: Alignment.center,
                              child: Text("Category 1",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          Text("$bullet Dummy link 1"),
                          Text("$bullet Dummy link 2"),
                          Text("$bullet Dummy link 3"),
                        ],
                      ),
                    )),
                const SizedBox(height: 20.0),

                // the 2nd box displayed
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all()),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Align(
                              alignment: Alignment.center,
                              child: Text("Category 2",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          Text("$bullet Dummy link 1"),
                          Text("$bullet Dummy link 2"),
                          Text("$bullet Dummy link 3"),
                        ],
                      ),
                    )),
                const SizedBox(height: 20.0),

                // the 3rd box displayed
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all()),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Align(
                              alignment: Alignment.center,
                              child: Text("Category 3",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          Text("$bullet Dummy link 1"),
                          Text("$bullet Dummy link 2"),
                          Text("$bullet Dummy link 3"),
                        ],
                      ),
                    )),
              ],
            )));
  }
}
