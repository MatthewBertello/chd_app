// ignore: file_names
import 'package:flutter/material.dart';
import '../models/main_model.dart';
import 'package:intl/intl.dart';

class ShareScreen extends StatefulWidget {
  const ShareScreen({super.key, required this.model});
  final MainModel model;

  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  TextEditingController textController = TextEditingController();

  // Builds an app bar with a textfield to search for members in the app
  AppBar buildAppBar(BuildContext context) {
    return AppBar(
        title: TextField(
      controller: textController,
      textAlign: TextAlign.start,
      maxLines: 1,
    ));
  }

  // Displays the members with list tiles
  Widget displayMembers(BuildContext context) {
    if (widget.model.membersSearched.isEmpty) {
      return const Expanded(
          child: Center(
        child: Text("There is no member found"),
      ));
    } else {
      return Expanded(
          child: ListView.separated(
              separatorBuilder: (context, index) =>
                  Divider(color: Colors.indigo[900]),
              itemCount: widget.model.membersSearched.length,
              itemBuilder: (BuildContext context, int index) {
                // Format the member's birth date
                final DateFormat formatter = DateFormat('yyyy-MM-dd');
                final String formatedBirthDate = formatter
                    .format(widget.model.membersSearched[index].birthDate);

                return ListTile(
                    // Display the name and date of birth and a share button
                    title: Text(widget.model.membersSearched[index].name),
                    subtitle: Text(formatedBirthDate),
                    trailing: IconButton(
                        onPressed: null,
                        icon: Icon(
                          Icons.offline_share,
                          color: Colors.red[200],
                        )));
              }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context),
        body: Column(children: [displayMembers(context)]));
  }
}
