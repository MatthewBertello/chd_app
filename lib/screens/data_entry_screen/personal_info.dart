import 'package:chd_app/components/default_app_bar.dart';
import 'package:chd_app/models/personal_info_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:provider/provider.dart';

class PersonalInfo extends StatefulWidget {
  const PersonalInfo({super.key}); //creates class

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  bool loading = false;

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
    ///build method, returns dropdown menu
    return Scaffold(
        appBar: DefaultAppBar(
            context: context, title: const Text('Personal Information')),
        body: buildBody(context));
  }

  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        ExpansionTile(
            title: const Text('Demographics',
                style: TextStyle(
                    color: Colors.purple, fontWeight: FontWeight.bold)),
            children: [
              createListView(Provider.of<PersonalInfoModel>(context)
                  .demographicsFormFields)
            ]),
        ExpansionTile(
            title: const Text('Social',
                style: TextStyle(
                    color: Colors.purple, fontWeight: FontWeight.bold)),
            children: [
              createListView(
                  Provider.of<PersonalInfoModel>(context).socialsFormFields)
            ]),
        ExpansionTile(
            title: const Text('Physical',
                style: TextStyle(
                    color: Colors.purple, fontWeight: FontWeight.bold)),
            children: [
              createListView(
                  Provider.of<PersonalInfoModel>(context).physicalsFormFields)
            ])
      ]),
    );
  }

  Widget createListView(List<Map<String, dynamic>> items) {
    return ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        separatorBuilder: (context, index) {
          return const Divider(
            height: 1,
          );
        },
        itemCount: items.length,
        itemBuilder: (context, index) {
          if (items[index]['isTextFormField']) {
            return ListTile(
                title: Text(items[index]['title']),
                trailing: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 100,
                      child: items[index]['input'] ?? const Text("Error"),
                    ),
                  ),
                ));
          } else {
            return ListTile(
                title: Text(items[index]['title']),
                subtitle: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment
                          .start, // Align columns to the start
                      mainAxisSize: MainAxisSize.min,
                      children: items[index]['input'],
                    )));
          }
        });
  }
}
