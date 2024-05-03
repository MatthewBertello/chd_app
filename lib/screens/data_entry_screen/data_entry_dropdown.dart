import 'package:chd_app/components/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'demographic_data_entry.dart';
import 'physical_data_entry.dart';
import 'social_data_entry.dart';

class DataDropdown extends StatefulWidget {
  const DataDropdown({super.key});

  @override
  State<DataDropdown> createState() => _DataDropdownState();
}

class _DataDropdownState extends State<DataDropdown> {
  @override
  Widget build (BuildContext context){
     return Scaffold(appBar: DefaultAppBar(context: context, 
     title: const Text('enter your data here')),
     body: buildForm(context)
     );
     
  }

String _selectedItem ='demographic';

  Column buildForm(BuildContext context){
    List <DropdownMenuItem<dynamic>> data = [
      const DropdownMenuItem(value:'demographic',child: Text("demographics"),),
      const DropdownMenuItem(value:'Physical',child: Text("physical"),),
      const DropdownMenuItem(value:'Social',child: Text("social"),),
    ];
    return Column(
      children:[
        DropdownButtonFormField(
          items: data,
          onChanged:(value) => setState(()=>_selectedItem = value),
          value:_selectedItem
        )
      ]
    );
  }
}
