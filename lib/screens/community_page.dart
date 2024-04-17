import 'dart:ffi';
import 'package:chd_app/components/default_app_bar.dart';
import 'package:chd_app/components/health_meter.dart';
import 'package:chd_app/components/pregnancy_countdown.dart';
import 'package:chd_app/components/tile.dart';
import 'package:chd_app/models/main_model.dart';
import 'package:chd_app/screens/question_forum_screen/question_listview.dart';
import 'package:flutter/material.dart';
import 'package:chd_app/models/question_forum_model.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class CommunityPage extends StatelessWidget//<CommunityPage> 
{
  const CommunityPage({super.key});

@override
Widget build(BuildContext context){
  return Consumer<QuestionForumModel>(builder: (context, questionsChangeNotifier, child) =>  
          QuestionListView(questionForumModel: questionsChangeNotifier));
}

}