// ignore: file_names
import 'package:flutter/material.dart';
import 'test_model.dart';
import 'package:intl/intl.dart';


class ShareScreen extends StatefulWidget {
  const ShareScreen({super.key, required this.model});
  final TestModel model;

  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {

  // Builds an app bar with a textfield to search for members in the app
  AppBar buildAppBar(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.red[600],
        title: Container(
          padding: const EdgeInsets.all(3.0),
          height: 45,
          width: 350, 
          child: TextField(
            textAlign: TextAlign.start,
            maxLines: 1,
            style: TextStyle(fontSize: 15, color: Colors.indigo[900]),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              alignLabelWithHint: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              hintText: 'Find a Member',
              filled: true,
              fillColor: Colors.white,
              suffixIcon: IconButton(onPressed: () => widget.model.searchMember("member"), icon: Icon(Icons.search, color: Colors.blueGrey[400]),
            ),
          ),
        ),
      ),
    );
  }

  // Displays the members with list tiles
  Widget displayMembers(BuildContext context) {
    if (widget.model.members.isEmpty) {
      return const Expanded(child: Center(child: Text("There is no member found"),));
    } else {
      return Expanded(child: ListView.separated(separatorBuilder: (context, index) => Divider(color: Colors.indigo[900]), 
      itemCount: widget.model.members.length,
      itemBuilder: (BuildContext context, int index) { 
        // Format the member's birth date
        final DateFormat formatter = DateFormat('yyyy-MM-dd');
        final String formatedBirthDate = formatter.format(widget.model.members[index].birthDate);

        return ListTile( // Display the name and date of birth and a share button
          title: Text(widget.model.members[index].name),
          subtitle: Text(formatedBirthDate),
          trailing: IconButton(onPressed: null, icon: Icon(Icons.offline_share, color: Colors.red[200],))
        );
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
