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
  TextEditingController textController = TextEditingController();

  // Builds an app bar with a textfield to search for members in the app
  AppBar buildAppBar(BuildContext context) {
    return AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration( // Gives the app bar a gradient red color 
            gradient: LinearGradient(colors:  <Color>[const Color.fromARGB(255, 249, 0, 0).withOpacity(0.9), const Color.fromARGB(223, 189, 0, 0).withOpacity(0.9)])
          )
        ),
        title: Container( // Contains a textfield
          padding: const EdgeInsets.all(3.0),
          height: 45,
          width: 350, 
          child: TextField(
            controller: textController,
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
              suffixIcon: IconButton(onPressed: () => widget.model.searchMember(textController.text), icon: Icon(Icons.search, color: Colors.blueGrey[400]),
            ),
          ),
        ),
      ),
    );
  }

  // Displays the members with list tiles
  Widget displayMembers(BuildContext context) {
    if (widget.model.membersSearched.isEmpty) {
      return const Expanded(child: Center(child: Text("There is no member found"),));
    } else {
      return Expanded(child: ListView.separated(separatorBuilder: (context, index) => Divider(color: Colors.indigo[900]), 
      itemCount: widget.model.membersSearched.length,
      itemBuilder: (BuildContext context, int index) { 
        // Format the member's birth date
        final DateFormat formatter = DateFormat('yyyy-MM-dd');
        final String formatedBirthDate = formatter.format(widget.model.membersSearched[index].birthDate);

        return ListTile( // Display the name and date of birth and a share button
          title: Text(widget.model.membersSearched[index].name),
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
