import 'package:chd_app/components/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'demographic_data_entry.dart';
import 'physical_data_entry.dart';
import 'social_data_entry.dart';

class DataDropdown extends StatefulWidget {
  const DataDropdown({super.key});  //creates class

  @override
  State<DataDropdown> createState() => _DataDropdownState();
}

class _DataDropdownState extends State<DataDropdown> {
  @override 
  Widget build (BuildContext context){ ///build method, returns dropdown menu
     return Scaffold(appBar: DefaultAppBar(context: context, 
     title: const Text('enter your data here')),
     body: buildForm(context)
     );
     
  }
///this is the page shown when the user clicks on 'health and wellness' on the burger menu screen
String _selectedItem ='demographic';

  Column buildForm(BuildContext context){
    List <DropdownMenuItem<dynamic>> data = [ ///selected options in the menu
      const DropdownMenuItem(value:'demographic',child: Text("demographics"),),
      const DropdownMenuItem(value:'Physical',child: Text("physical"),),
      const DropdownMenuItem(value:'Social',child: Text("social"),),
    ];
    return Column(
      children:[
        DropdownButtonFormField(
          items: data, ///displays dropdown
          onChanged:(value) => setState(()=>_selectedItem = value),
          value:_selectedItem  ///selected item is set as the curent view in the dropdown menu
        )
      ]
    );
  }
}
