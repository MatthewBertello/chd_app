import 'dart:ffi';
import 'package:chd_app/components/default_app_bar.dart';
import 'package:chd_app/components/health_meter.dart';
import 'package:chd_app/components/pregnancy_countdown.dart';
import 'package:chd_app/components/tile.dart';
import 'package:chd_app/models/main_model.dart';
import 'package:flutter/material.dart';
import 'package:chd_app/models/question_forum_model.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
///GRACE DO
// Where the user sees the questions and has the option to add a question or reply to the questions
class CommunityPage extends StatefulWidget{
  const CommunityPage({super.key, required this.questionForumModel});
  
  final QuestionForumModel questionForumModel;

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
@override
Widget build(BuildContext context){
  return Scaffold(
    appBar: DefaultAppBar(
      context: context,
      title: const Text("Question Forum"),
    ),
    body: Column( crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: ListView.builder( // builder shows all the questions that have been asked
            itemCount: widget.questionForumModel.questionsList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(widget.questionForumModel.questionsList[index].getQuestion(), 
                  style: const TextStyle(fontWeight: FontWeight.bold)), // prints question
                subtitle: const Text("The Author"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                  Consumer<QuestionForumModel>(builder: (context, questionsChangeNotifier, child) =>  
                  QuestionReplies(questionForumModel: widget.questionForumModel, questionIndex: index)
                  )));
                }
              );
            },
          )
        ),
        Padding(padding: const EdgeInsets.all(8.0), 
          child: FloatingActionButton(onPressed: _addQuestion, child: const Icon(Icons.add))
        ) // add question button
      ],
    )
  );
}
void _addQuestion() {    
  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  AddQuestion(questionForumModel: widget.questionForumModel)));
}

}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Shows the replies of the question clicked
class QuestionReplies extends StatefulWidget {
  const QuestionReplies({super.key, required this.questionForumModel, required this.questionIndex});

  final QuestionForumModel questionForumModel;
  final int questionIndex;

  @override
  State<QuestionReplies> createState() => QuestionRepliesState();
}

class QuestionRepliesState extends State<QuestionReplies> {
  TextEditingController replyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: DefaultAppBar(
      context: context,
      title: const Text("Replies"),
    ),
    body:
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.questionForumModel.questionsList[widget.questionIndex].getQuestion(), 
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
            const Divider(height: 1.0, thickness: 1.0, color: Colors.black),
            Expanded(
              child: ListView.builder( // builder shows all the replies of the question
                itemCount: widget.questionForumModel.questionsList[widget.questionIndex].replies.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(widget.questionForumModel.questionsList[widget.questionIndex].replies[index]),
                    subtitle: const Text("The Author"), // prints the author just hardcoded for now
                  );
                },
              )
            ),
            Row( // where the user can make a reply
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: TextField(
                    controller: replyController,
                    decoration: const InputDecoration(
                      //enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.lightBlue, width: 2.0)),
                      //focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.lightBlue, width: 2.0)),
                      isDense: true,
                      contentPadding: EdgeInsets.all(10),
                      hintText: "(Reply)"
                    )
                  ) 
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: ElevatedButton.icon(
                    onPressed: _addReply,
                    icon: const Icon(Icons.add),
                    label: const Text("Reply"),
                    style: ElevatedButton.styleFrom(
                      //backgroundColor: Colors.lightBlue,
                      //foregroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))
                    )
                  )
                )
              ]
            )
          ],
        ),
      )
    );
  }

void _addReply() { // adds a reply to the question
  if (replyController.text != ""){
    widget.questionForumModel.addReply(widget.questionIndex, replyController.text);
    replyController.text = "";
  }
}

}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// This page adds a question to the forum
class AddQuestion extends StatefulWidget {
  const AddQuestion({super.key, required this.questionForumModel});

  final QuestionForumModel questionForumModel; // model for the community page

  @override
  State<AddQuestion> createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {

  TextEditingController questionController = TextEditingController(); // controller for the new question

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
      context: context,
      title: const Text("Add Question"),
    ),
    body:
      Padding(
        padding: const EdgeInsets.all(8.0), 
        child: Column( 
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField( // where the user enters a new question
              controller: questionController,
              decoration: const InputDecoration(
                //enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.lightBlue, width: 2.0)),
                //focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.lightBlue, width: 2.0)),
                isDense: true,
                contentPadding: EdgeInsets.all(10),
                hintText: "(New Question)"
              )
            ),
            ElevatedButton(          
              onPressed: _addQuestion,
              style: ElevatedButton.styleFrom(
                //backgroundColor: Colors.lightBlue,
                //foregroundColor: Colors.white,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))),
              child: const Text('Post')
            )              
          ],  
        )
      )
    );
  }
  
  // adds question to the forum
  void _addQuestion() {
    if (questionController.text != ""){
      widget.questionForumModel.addQuestion(questionController.text);
      Navigator.pop(context);
    }
    questionController.text = "";
  }

}