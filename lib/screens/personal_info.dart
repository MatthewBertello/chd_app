// ignore: unused_import
import 'package:date_field/date_field.dart';
import 'package:heart_safe/components/default_app_bar.dart';
import 'package:heart_safe/models/personal_info_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
///Author: Grace Kiesau, Pachia Lee
///Date: 5/14/24
///Description: This is the file where the user enters variables that should remain constant. 
///Bugs: None Known
///reflection: pretty straightforward
class PersonalInfo extends StatefulWidget {
  const PersonalInfo({super.key}); //creates class

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  bool loading = false;
  var userInfo;

  @override
  void initState() {
    // Initialize the model if it has not been loaded
    if (Provider.of<PersonalInfoModel>(context, listen: false).loaded ==
            false &&
        Provider.of<PersonalInfoModel>(context, listen: false).loading ==
            false) {
      Provider.of<PersonalInfoModel>(context, listen: false).init();
    }
    Provider.of<PersonalInfoModel>(context, listen: false).selectedDate =
        DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userInfo = Provider.of<PersonalInfoModel>(context).variables;

    ///build method, returns dropdown menu
    return Scaffold(
        appBar: DefaultAppBar(
            context: context, title: const Text('Personal Information')),
        body: buildBody(context));
  }

  Widget buildBody(BuildContext context) {
    List<dynamic> demoItems = [];
    List<dynamic> socialItems = [];
    List<dynamic> physicalItems = [];
    List<dynamic> mentalItems = [];

    for (var key in userInfo.keys) {
      if (userInfo[key]!['category'] == 'Demographic') {
        demoItems.add(userInfo[key]!);
      } else if (userInfo[key]!['category'] == 'Social') {
        socialItems.add(userInfo[key]!);
      } else if (userInfo[key]!['category'] == 'Physical') {
        physicalItems.add(userInfo[key]!);
      } else if (userInfo[key]!['category'] == 'Mental') {
        mentalItems.add(userInfo[key]!);
      }
    }

    return SingleChildScrollView(
      child: Column(children: [
        ExpansionTile(
            title: const Text('Demographics',
                style: TextStyle(
                    color: Colors.purple, fontWeight: FontWeight.bold)),
            children: [createListView(demoItems)]),
        ExpansionTile(
            title: const Text('Social',
                style: TextStyle(
                    color: Colors.purple, fontWeight: FontWeight.bold)),
            children: [createListView(socialItems)]),
        ExpansionTile(
            title: const Text('Physical',
                style: TextStyle(
                    color: Colors.purple, fontWeight: FontWeight.bold)),
            children: [createListView(physicalItems)]),
        ExpansionTile(
            title: const Text('Mental',
                style: TextStyle(
                    color: Colors.purple, fontWeight: FontWeight.bold)),
            children: [createListView(mentalItems)]),
      ]),
    );
  }

  Widget createListView(List<dynamic> items) {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (context, index) {
          return const Divider(
            height: 1,
          );
        },
        itemCount: items.length,
        itemBuilder: (context, index) {
          if (items[index]['unit'] == 'text' ||
              items[index]['unit'] == 'int') {
            return ListTile(
              title: Text(items[index]['title']),
              subtitle: Padding(
                padding: const EdgeInsets.all(8),
                child: Focus(
                  child: items[index]['input'] ?? const Text("Error"),
                  onFocusChange: (value) {
                    if (!value) {
                      Provider.of<PersonalInfoModel>(context, listen: false)
                          .saveSelectedToDb(items[index]['key'],
                              items[index]['input']!.controller!.text);
                    }
                  },
                ),
              ),
            );
          } else if (items[index]['unit'] == 'date') {
            return ListTile(
              title: Text(items[index]['title']),
              subtitle: Padding(
                padding: const EdgeInsets.all(8),
                child: items[index]['input'] ?? const Text("Error"),
              ),
            );
          } else {
            return ListTile(
                title: Text(items[index]['title']),
                subtitle: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment
                          .start, // Align columns to the start
                      mainAxisSize: MainAxisSize.min,
                      children: createRadioButtons(items[index]['key']),
                    )));
          }
        });
  }

  List<Widget> createRadioButtons(String key) {
    List<Widget> varWithRadioButtons = [];

    // Add a radio button to all of the different types in the variable category
    for (var type in userInfo[key]!['values']) {
      var radioButton = Radio<String>(
        value: type['enumlabel'],
        groupValue: userInfo[key]!['value'],
        onChanged: (value) {
          setState(() {
            userInfo[key]!['value'] = value;
            Provider.of<PersonalInfoModel>(context, listen: false)
                .saveSelectedToDb(userInfo[key]['unit'], value);
          });
        },
      );

      var title = Text(type['enumlabel']);

      varWithRadioButtons.add(Row(children: [radioButton, title]));
    }

    return varWithRadioButtons;
  }
}
