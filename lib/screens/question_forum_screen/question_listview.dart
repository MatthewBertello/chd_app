import 'package:chd_app/components/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:chd_app/models/question_forum_model.dart';
import 'package:provider/provider.dart';
import 'add_question_screen.dart';
import 'question_replies_screen.dart';
import 'package:chd_app/main.dart';

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
  if (!initialized){ // loads the question list when the community page is loaded first time
    _initQuestionsList();
    initialized = true;
  }
  return Scaffold(
    appBar: DefaultAppBar(
      context: context,
      title: const Text("Question Forum"),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {(supabase.auth.currentUser?.id != null) ? _addQuestion() : _showNoAccountWarning();}, 
      child: const Icon(Icons.add)
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

// alerts the user that an account is necesarry to post a question
Future<void> _showNoAccountWarning() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Error'),
        content: const Text("You must have an account to post a question."),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

}