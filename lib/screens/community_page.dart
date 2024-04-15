import 'dart:ffi';
import 'package:chd_app/components/default_app_bar.dart';
import 'package:chd_app/components/health_meter.dart';
import 'package:chd_app/components/pregnancy_countdown.dart';
import 'package:chd_app/components/tile.dart';
import 'package:chd_app/models/main_model.dart';
import 'package:flutter/material.dart';
///GRACE DO
class CommunityPage extends StatelessWidget{
  const CommunityPage({super.key});

@override
Widget build(BuildContext context){
  return Scaffold(
  appBar: DefaultAppBar(
        context: context,
        title: Text("Question Forum"),
      ),
       body: Center(
        child: Column(
         children: [
          
         ]
       ),
    )
 );
}

///function that updates the listview so the most popular question is the first seen
//Void numhits(){


//}


}