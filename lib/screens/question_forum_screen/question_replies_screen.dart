import 'package:chd_app/components/default_app_bar.dart';
import 'package:chd_app/screens/question_forum_screen/edit_reply_screen.dart';
import 'package:flutter/material.dart';
import 'package:chd_app/models/question_forum_model.dart';
import 'package:chd_app/main.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class QuestionReplies extends StatefulWidget {
  const QuestionReplies({super.key, required this.questionForumModel, required this.questionIndex});

  final QuestionForumModel questionForumModel; // model
  final int questionIndex; // index of the question in the list

  @override
  State<QuestionReplies> createState() => QuestionRepliesState();
}

class QuestionRepliesState extends State<QuestionReplies> {
  TextEditingController replyController = TextEditingController(); // controller for the reply text box

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(context: context, title: const Text("Replies")),
      body: (widget.questionForumModel.loaded) ? replyListView() : loadingAnimationWidget(context)
    );
  }


  // the list view of replies
  Padding replyListView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.questionForumModel.questionsList[widget.questionIndex].getQuestion(), 
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
          const Divider(height: 15.0, thickness: 2.0, color: Colors.black),
          Expanded(
            child: ListView.separated( // builder shows all the replies of the question
              itemCount: widget.questionForumModel.questionsList[widget.questionIndex].replies.length,
              itemBuilder: (context, index) {
                return (supabase.auth.currentUser?.id == widget.questionForumModel.questionsList[widget.questionIndex].replies[index].getUserWhoPosted()) ? currentUserReply(widget.questionIndex, index) : notCurrUserReply(widget.questionIndex, index);
              },
              separatorBuilder: (BuildContext context, int index) { return const Divider(color: Colors.transparent, height: 5.0); }
            )
          ),
          newReplyRow() // where the user can post a new reply
        ],
      ),
    );
  }

  // loading animation while the replies load
  Stack loadingAnimationWidget(BuildContext context) {
    return Stack(
      children: [
        ModalBarrier(color: Colors.black.withOpacity(0.3), dismissible: false),
        Center(child: LoadingAnimationWidget.fourRotatingDots(color: Theme.of(context).colorScheme.primary, size: 50))
      ],
    );
  }

  // the user who posted the question is currently logged in
  ListTile currentUserReply(int questionIndex, int replyIndex) {
    return ListTile(
      title: Text(widget.questionForumModel.questionsList[widget.questionIndex].replies[replyIndex].getReply()),
      subtitle: const Text("The Author"), // prints the author just hardcoded for now
      tileColor: Theme.of(context).colorScheme.primaryContainer,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  EditReply(questionForumModel: widget.questionForumModel, reply: widget.questionForumModel.questionsList[questionIndex].replies[replyIndex].getReply(), questionIndex: questionIndex, replyIndex: replyIndex,)));}, icon: const Icon(Icons.edit)),
          IconButton(onPressed: () {_deleteReplyVerification(questionIndex, replyIndex);}, icon: const Icon(Icons.delete))
        ]
      ),
    );
  }

  // the user who posted the question is not currently logged in
  ListTile notCurrUserReply(int questionIndex, int replyIndex) {
    return ListTile(
      title: Text(widget.questionForumModel.questionsList[widget.questionIndex].replies[replyIndex].getReply()),
      subtitle: const Text("The Author"), // prints the author just hardcoded for now
      tileColor: Theme.of(context).colorScheme.primaryContainer,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
    );
  }

  // where the user can type a reply
  Row newReplyRow() {
    return Row( // where the user can make a reply
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: (supabase.auth.currentUser?.id != null) ? hasAccountReplyTextField() : noAccountReplyTextField()), 
        const SizedBox(width: 8.0),
        ElevatedButton.icon(
          onPressed: () {(supabase.auth.currentUser?.id != null) ? _addReply() : _showNoAccountWarning();},
          icon: const Icon(Icons.add),
          label: const Text("Reply"),
          style: ElevatedButton.styleFrom(shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))))
        )
      ]
    );      
  }

  // allows user to type in the textfield if they have an account
  TextField hasAccountReplyTextField() {
    return TextField(
      controller: replyController,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      inputFormatters: [LengthLimitingTextInputFormatter(250)],
      decoration: const InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.all(10),
        hintText: "(Reply)"
      )
    );
  }
  
  // disallows user from user textfield with no account, and shows the warning
  GestureDetector noAccountReplyTextField() {
    return GestureDetector(
      onTap: _showNoAccountWarning,
      child: const TextField(
        enabled: false,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.all(10),
          hintText: "(Reply)")
      ),
    );
  }

  // adds a reply to the question
  void _addReply() { // adds a reply to the question
    if (replyController.text != ""){
      widget.questionForumModel.addReply(widget.questionIndex, replyController.text);
      replyController.text = "";
    }
  }

  // alerts the user that an account is necesarry to post a reply
  Future<void> _showNoAccountWarning() async {
    replyController.text = "";
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text("You must have an account to post a reply."),
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

  // gives the user a chance to verify they want to delete their reply
  Future<void> _deleteReplyVerification(int questionIndex, int replyIndex) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: const Text("Are you sure you want to delete your reply?"),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.black, width: 2.0), borderRadius: BorderRadius.all(Radius.circular(15.0))),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                widget.questionForumModel.deleteReply(questionIndex, replyIndex);
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