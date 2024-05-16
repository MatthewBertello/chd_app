// ignore: file_names
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/main_model.dart';
import 'package:heart_safe/components/default_app_bar.dart';

///Author: 
///Date: 5/14/24
///Description: not implimented
///Bugs: None Known
class ShareScreen extends StatefulWidget {
  const ShareScreen({super.key});

  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    Provider.of<MainModel>(context, listen: false).clearMembersSearched();
    super.initState();
  }

  // Displays the members with list tiles
  Widget displayMembers(BuildContext context) {
    if (Provider.of<MainModel>(context).membersSearched.isEmpty) {
      return const Expanded(
          child: Center(
        child: Text("There is no member found"),
      ));
    } else {
      return Expanded(
          child: ListView.separated(
              separatorBuilder: (context, index) =>
                  Divider(color: Colors.indigo[900]),
              itemCount: Provider.of<MainModel>(context).membersSearched.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                    // Display the name and date of birth and a share button
                    title: Text(Provider.of<MainModel>(context).membersSearched[index]),
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
        appBar: DefaultAppBar(context: context, title: Container(
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
              suffixIcon: IconButton(onPressed: () => Provider.of<MainModel>(context, listen: false).searchMember(textController.text), icon: Icon(Icons.search, color: Colors.blueGrey[400]),
            ),
          )
        ),)),
        body: Column(children: [displayMembers(context)]));
  }
}
