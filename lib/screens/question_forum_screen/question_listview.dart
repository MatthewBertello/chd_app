import 'package:chd_app/components/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:chd_app/models/question_forum_model.dart';
import 'package:provider/provider.dart';
import 'add_question_screen.dart';
import 'question_replies_screen.dart';

// Where the user sees the questions and has the option to add a question or reply to the questions
class QuestionListView extends StatefulWidget{
  const QuestionListView({super.key, required this.questionForumModel});
  
  final QuestionForumModel questionForumModel; // model for the questions

  @override
  State<QuestionListView> createState() => _QuestionListViewState();
}

class _QuestionListViewState extends State<QuestionListView> {

bool initialized = false;

@override
Widget build(BuildContext context){
  if (!initialized){ // loads the question list when the app is first loaded
    _initQuestionsList();
    initialized = true;
  }
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
                  widget.questionForumModel.loadReplyList(index);
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                  Consumer<QuestionForumModel>(builder: (context, questionsChangeNotifier, child) =>  
                  QuestionReplies(questionForumModel: widget.questionForumModel, questionIndex: index)
                  )));
                },
                onLongPress: () {
                  widget.questionForumModel.deleteQuestion(index); // delete the question on long press            
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

// adds a question
void _addQuestion() {    
  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  AddQuestion(questionForumModel: widget.questionForumModel)));
}

// deletes a question
void _initQuestionsList() {
  widget.questionForumModel.loadQuestionList();
}

}