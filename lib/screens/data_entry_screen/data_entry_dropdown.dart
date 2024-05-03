import 'package:chd_app/components/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'demographic_data_entry.dart';
import 'physical_data_entry.dart';
import 'social_data_entry.dart';
import 'package:searchable_listview/searchable_listview.dart';

class DataDropdown extends StatefulWidget {
  const DataDropdown({super.key});  //creates class

  @override
  State<DataDropdown> createState() => _DataDropdownState();
}

class _DataDropdownState extends State<DataDropdown> {

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

  ListView createListView() {
    return ListView(

    );
  }


}
