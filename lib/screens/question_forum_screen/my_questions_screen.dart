import 'package:chd_app/components/default_app_bar.dart';
import 'package:chd_app/models/question_forum_model/question_forum_model.dart';
import 'package:chd_app/screens/question_forum_screen/question_replies_screen.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class MyQuestions extends StatefulWidget {
  const MyQuestions({super.key, required this.questionForumModel});

  final QuestionForumModel questionForumModel;

  @override
  State<MyQuestions> createState() => _MyQuestionsState();
}

class _MyQuestionsState extends State<MyQuestions> {

  bool isLiked = false; // whether not this question was liked by you

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: DefaultAppBar(
        context: context, 
        title: const Text("My Questions")
      ),
      body: (!widget.questionForumModel.loaded) 
        ? 
        loadingAnimationWidget(context) 
        : 
        ((widget.questionForumModel.myQuestionsList.isEmpty)
        ? 
        const Center(child: Text("You haven't posted any questions yet."),) 
        :
        myQuestionListView())
    );
  }


  // build the listview of user's questions
  Padding myQuestionListView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child:Column( crossAxisAlignment: CrossAxisAlignment.end,
       children: [
         Expanded(
           child: ListView.separated( // builder shows all the questions that have been asked
             itemCount: widget.questionForumModel.myQuestionsList.length,
             itemBuilder: (context, index) {
               return myQuestionListTile(index);
             }, 
             separatorBuilder: (BuildContext context, int index) { return const Divider(color: Colors.transparent, height: 5.0); }
           )
         ),
       ],
     ),
    );
  }

  // the tile of each question
  ListTile myQuestionListTile(int questionIndex) {
    isLiked = widget.questionForumModel.likedQuestionsList.contains(widget.questionForumModel.myQuestionsList[questionIndex].getQuestionID());
    return ListTile(
      title: Text(widget.questionForumModel.myQuestionsList[questionIndex].getQuestion(), 
      style: const TextStyle(fontWeight: FontWeight.bold)), // prints question
      subtitle: (widget.questionForumModel.myQuestionsList[questionIndex].getAuthor() == 'NULL')
      ?
      const Text("Anonymous", style: TextStyle(color: Colors.red),)
      :
      Text(widget.questionForumModel.myQuestionsList[questionIndex].getAuthor()),
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
        .then((_) => setState((){widget.questionForumModel.getMyQuestions();}));
      },
    );
  }

  // like button for questions
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
        likeCount: widget.questionForumModel.myQuestionsList[questionIndex].numLikes,
        isLiked: isLiked,
        onTap: (bool isLiked) {
          this.isLiked = !isLiked;
          (isLiked) 
          ? 
          widget.questionForumModel.unlikeQuestion(widget.questionForumModel.questionsList.indexWhere((element) => element.getQuestionID() == widget.questionForumModel.myQuestionsList[questionIndex].getQuestionID())) 
          : 
          widget.questionForumModel.likeQuestion(widget.questionForumModel.questionsList.indexWhere((element) => element.getQuestionID() == widget.questionForumModel.myQuestionsList[questionIndex].getQuestionID()));
          return Future.value(!isLiked);
        }
      ),
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

  // loading animation while the question load
  Stack loadingAnimationWidget(BuildContext context) {
    return Stack(
      children: [
        ModalBarrier(color: Colors.black.withOpacity(0.3), dismissible: false),
        Center(child: LoadingAnimationWidget.fourRotatingDots(color: Theme.of(context).colorScheme.primary, size: 50))
      ],
    );
  }

}