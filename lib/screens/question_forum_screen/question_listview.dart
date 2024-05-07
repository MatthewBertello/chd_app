import 'package:chd_app/components/default_app_bar.dart';
import 'package:chd_app/screens/question_forum_screen/my_questions_screen.dart';
import 'package:flutter/material.dart';
import 'package:chd_app/models/question_forum_model/question_forum_model.dart';
import 'package:like_button/like_button.dart';
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

  bool initialized = false; // whether or not the page has been initialized
  bool isLiked = false; // whether not this question was liked by you
  bool isNull = true; // so it doesn't show which choice there is by the sort button

  @override
  void initState() {
    super.initState();
    _initQuestionsList();
    initialized = true;

  }

  List<String> sortChoices = [ 'Newest', 'Oldest', 'Most Popular', 'Least Popular']; // choices for sorting
  String selectedSortChoice = 'Newest'; // the default choice

  void sortBy(String? choice){ // sorts the questions based off some choices in the dropdown
    if (initialized) {  
      switch (choice){
        case 'Newest': {setState(() {widget.questionForumModel.sortQuestionByNewest();});} break;
        case 'Oldest': {setState(() {widget.questionForumModel.sortQuestionsByOldest();});} break;
        case 'Most Popular': {setState(() {widget.questionForumModel.sortQuestionsByMostPopular();});} break;
        case 'Least Popular': {setState(() {widget.questionForumModel.sortQuestionsByLeastPopular();});} break;
      }
    }
  }

  void seeMyQuestions() { // go to the archive and view your questions
    if (supabaseModel.supabase!.auth.currentUser?.id == null) {
    _showNoAccountWarning();
    }
    else {
    widget.questionForumModel.getMyQuestions();
        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
        Consumer<QuestionForumModel>(builder: (context, questionsChangeNotifier, child) =>  
        MyQuestions(questionForumModel: widget.questionForumModel))))
        .then((_) => setState((){widget.questionForumModel.loadQuestionList();}));
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: DefaultAppBar(
        context: context, 
        title: const Text("Question Forum"),
        actions: [
          DropdownButton( 
            iconDisabledColor: Theme.of(context).colorScheme.primaryContainer,
            iconEnabledColor: Theme.of(context).colorScheme.primaryContainer,
            value: (isNull) ? null : selectedSortChoice,
            underline: Container(),
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
            icon: const Icon(Icons.sort_rounded),     
            items: sortChoices.map((String items) { 
              return DropdownMenuItem(value: items, child: Text(items));
            }).toList(), 
            onChanged: (String? newValue) {  
              setState(() { 
                sortBy(newValue);
              }); 
            }, 
          ),
          IconButton(
            onPressed: seeMyQuestions, 
            icon: const Icon(Icons.archive_rounded),
            color: Theme.of(context).colorScheme.primaryContainer,
            focusColor: Theme.of(context).colorScheme.primaryContainer
          ),
          const SizedBox(width: 8.0)
        ]
      ),
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
    isLiked = widget.questionForumModel.likedQuestionsList.contains(widget.questionForumModel.questionsList[questionIndex].questionID);
    return ListTile(
      title: Text(widget.questionForumModel.questionsList[questionIndex].getQuestion(), 
      style: const TextStyle(fontWeight: FontWeight.bold)), // prints question
      subtitle: (widget.questionForumModel.questionsList[questionIndex].getAuthor() == 'NULL')
      ?
      const Text("Anonymous", style: TextStyle(color: Colors.red),)
      :
      Text(widget.questionForumModel.questionsList[questionIndex].getAuthor())
      ,//const Text("The Author"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children:[
          likeButton(questionIndex),
          IconButton(onPressed: () {_deleteQuestionVerification(questionIndex);}, icon: const Icon(Icons.delete)),
        ]
      ),
      tileColor: Theme.of(context).colorScheme.primaryContainer,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
      onTap: () {
        widget.questionForumModel.loadReplyList(questionIndex);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
        Consumer<QuestionForumModel>(builder: (context, questionsChangeNotifier, child) =>  
        QuestionReplies(questionForumModel: widget.questionForumModel, questionIndex: questionIndex))))
        .then((_) => setState((){widget.questionForumModel.loadQuestionList();}));
      },
    );
  }

  // the user who posted the question is not currently logged in
  ListTile notCurrUserQuestion(int questionIndex) {
    isLiked = widget.questionForumModel.likedQuestionsList.contains(widget.questionForumModel.questionsList[questionIndex].questionID);
    return ListTile(
      title: Text(widget.questionForumModel.questionsList[questionIndex].getQuestion(), 
      style: const TextStyle(fontWeight: FontWeight.bold)), // prints question
      subtitle: (widget.questionForumModel.questionsList[questionIndex].getAuthor() == 'NULL')
      ?
      const Text("Anonymous", style: TextStyle(color: Colors.red),)
      :
      Text(widget.questionForumModel.questionsList[questionIndex].getAuthor()),//const Text("The Author"),
      tileColor: Theme.of(context).colorScheme.primaryContainer,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
      onTap: () {
        widget.questionForumModel.loadReplyList(questionIndex);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
        Consumer<QuestionForumModel>(builder: (context, questionsChangeNotifier, child) =>  
        QuestionReplies(questionForumModel: widget.questionForumModel, questionIndex: questionIndex))))
        .then((_) => setState((){widget.questionForumModel.loadQuestionList();}));
      },
      trailing: likeButton(questionIndex)
    );
  }

  SizedBox likeButton(int questionIndex) {
    return SizedBox(
      width: 50.0,
      child: LikeButton(
        animationDuration: const Duration(milliseconds: 0),
        circleColor: const CircleColor(
            start: Colors.transparent, end: Colors.transparent),
        bubblesColor: const BubblesColor(
            dotPrimaryColor: Colors.transparent,
            dotSecondaryColor: Colors.transparent,
            dotThirdColor: Colors.transparent,
            dotLastColor: Colors.transparent),
        bubblesSize: 0,
        likeCount: widget.questionForumModel.questionsList[questionIndex].numLikes,
        isLiked: isLiked,
        onTap: (bool isLiked) {
          if (supabaseModel.supabase!.auth.currentUser?.id == null) {
            _showNoAccountWarning();
            return Future.value(isLiked);
          }
          else{
            this.isLiked = !isLiked;
            (isLiked) 
            ? 
            widget.questionForumModel.unlikeQuestion(questionIndex) 
            : 
            widget.questionForumModel.likeQuestion(questionIndex);
          }
          return Future.value(!isLiked);
        }
      ),
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
          content: const Text("You must have an account to perform this action."),
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