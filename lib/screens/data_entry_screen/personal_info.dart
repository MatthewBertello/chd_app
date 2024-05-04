import 'package:chd_app/components/default_app_bar.dart';
import 'package:chd_app/models/personal_info_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'demographic_data_entry.dart';
import 'physical_data_entry.dart';
import 'social_data_entry.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:provider/provider.dart';

class PersonalInfo extends StatefulWidget {
  const PersonalInfo({super.key});  //creates class

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  bool loading = false;

  @override
  void initState() {
    // Initialize the model if it has not been loaded
    if (Provider.of<PersonalInfoModel>(context, listen: false).loaded == false &&
        Provider.of<PersonalInfoModel>(context, listen: false).loading == false) {
      Provider.of<PersonalInfoModel>(context, listen: false).init();
    }
    Provider.of<PersonalInfoModel>(context, listen: false).selectedDate =
        DateTime.now();
    super.initState();
  }

  @override 
  Widget build (BuildContext context){ ///build method, returns dropdown menu
     return Scaffold(appBar: DefaultAppBar(context: context, 
     title: const Text('Personal Information')),
     body: buildBody(context)
     );
  }

  Column buildBody(BuildContext context) {
    return const Column(
      children: [
        ExpansionTile(
          title: Text('Demographics'),
          children: []
        ),
        ExpansionTile(
          title: Text('Social'),
          children: []
        ),
        ExpansionTile(
          title: Text('Physical'),
          children: []
        )
      ]
    );
  }

  ListView createListView(List<Map<String, dynamic>> items) {
    return ListView.separated(
      separatorBuilder: (context, index) {return const Divider(height: 1,);},
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: items[index]['variable name'],
          trailing: Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(child: items[index]['input'],)
            )
        );
      }
    );
  }
}
