import 'package:chd_app/components/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:chd_app/models/question_forum_model.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
      appBar: DefaultAppBar(context: context, title: const Text("Question Forum")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {(supabaseModel.supabase!.auth.currentUser?.id != null) ? _addQuestion() : _showNoAccountWarning();}, 
        child: const Icon(Icons.add)
      ),
      body: (widget.questionForumModel.loaded) ? questionListView() : loadingAnimationWidget(context)
    );
  }


  // the list view of question
  Padding questionListView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child:Column( crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: ListView.separated( // builder shows all the questions that have been asked
              itemCount: widget.questionForumModel.questionsList.length,
              itemBuilder: (context, index) {
                return 
                  (supabaseModel.supabase!.auth.currentUser?.id == widget.questionForumModel.questionsList[index].getUserWhoPosted()) 
                  ?  
                  currentUserQuestion(index) : notCurrUserQuestion(index);
              }, 
              separatorBuilder: (BuildContext context, int index) { return const Divider(color: Colors.transparent, height: 5.0); }
            )
          ),
        ],
      ),
    );
  }

  // loading animation while the question load
  Stack loadingAnimationWidget(BuildContext context) {
    return Stack(
      children: [
        ModalBarrier(color: Colors.black.withOpacity(0.3), dismissible: false),
        Center(child: LoadingAnimationWidget.fourRotatingDots(color: Theme.of(context).colorScheme.primary, size: 50))
      ],
    );
  }

  // the user who posted the question is currently logged in
  ListTile currentUserQuestion(int questionIndex) {
    return ListTile(
      title: Text(widget.questionForumModel.questionsList[questionIndex].getQuestion(), 
      style: const TextStyle(fontWeight: FontWeight.bold)), // prints question
      subtitle: const Text("The Author"),
      trailing: IconButton(onPressed: () {_deleteQuestionVerification(questionIndex);}, icon: const Icon(Icons.delete)),
      tileColor: Theme.of(context).colorScheme.primaryContainer,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
      onTap: () {
        widget.questionForumModel.loadReplyList(questionIndex);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
        Consumer<QuestionForumModel>(builder: (context, questionsChangeNotifier, child) =>  
        QuestionReplies(questionForumModel: widget.questionForumModel, questionIndex: questionIndex))));
      },
    );
  }

  // the user who posted the question is not currently logged in
  ListTile notCurrUserQuestion(int questionIndex) {
    return ListTile(
      title: Text(widget.questionForumModel.questionsList[questionIndex].getQuestion(), 
      style: const TextStyle(fontWeight: FontWeight.bold)), // prints question
      subtitle: const Text("The Author"),
      tileColor: Theme.of(context).colorScheme.primaryContainer,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
      onTap: () {
        widget.questionForumModel.loadReplyList(questionIndex);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
        Consumer<QuestionForumModel>(builder: (context, questionsChangeNotifier, child) =>  
        QuestionReplies(questionForumModel: widget.questionForumModel, questionIndex: questionIndex))));
      },
    );
  }

  // adds a question
  void _addQuestion() {    
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddQuestion(questionForumModel: widget.questionForumModel)));
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
          shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.black, width: 2.0), borderRadius: BorderRadius.all(Radius.circular(15.0))),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () { Navigator.of(context).pop(); }
            ),
          ],
        );
      },
    );
  }

  // gives the user a chance to verify they want to delete their question
  Future<void> _deleteQuestionVerification(int questionIndex) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: const Text("Are you sure you want to delete your question?"),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.black, width: 2.0), borderRadius: BorderRadius.all(Radius.circular(15.0))),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                widget.questionForumModel.deleteQuestion(questionIndex);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () { Navigator.of(context).pop(); }
            ),
          ],
        );
      },
    );
  }

}