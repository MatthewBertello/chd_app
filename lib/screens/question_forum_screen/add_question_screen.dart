import 'package:heart_safe/components/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:heart_safe/models/question_forum_model/question_forum_model.dart';
import 'package:flutter/services.dart';

/*
Name: Matthew Steffens
Date: 5/13/2024
Description: This page allows you to add a question to the forum
Bugs: None I currently know of
Reflection: This page was fairly easy to implement, and it seems to work fine
*/

// add a question to the forum
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
              keyboardType: TextInputType.multiline,
              maxLines: null,
              inputFormatters: [LengthLimitingTextInputFormatter(250)],
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.all(10),
                hintText: "(New Question)"
              )
            ),
            ElevatedButton(          
              onPressed: _addQuestion,
              style: ElevatedButton.styleFrom(
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