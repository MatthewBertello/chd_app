import 'package:chd_app/components/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:chd_app/models/question_forum_model.dart';
import 'package:chd_app/main.dart';
import 'package:flutter/services.dart';

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
                    title: Text(widget.questionForumModel.questionsList[widget.questionIndex].replies[index].getReply()),
                    subtitle: const Text("The Author"), // prints the author just hardcoded for now
                    onLongPress: () {
                      widget.questionForumModel.deleteReply(widget.questionIndex, index); // delete the reply
                    }
                  );
                },
              )
            ),
            newReplyRow() // where the user can post a new reply
          ],
        ),
      )
    );
  }

  // where the user can type a reply
  Row newReplyRow() {
    return Row( // where the user can make a reply
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: TextField(
            controller: replyController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            inputFormatters: [LengthLimitingTextInputFormatter(250)],
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.all(10),
              hintText: "(Reply)"
            ),
          )
        ), 
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


  // adds a reply to the question
  void _addReply() { // adds a reply to the question
    if (replyController.text != ""){
      widget.questionForumModel.addReply(widget.questionIndex, replyController.text);
      replyController.text = "";
    }
  }

  // alerts the user that an account is necesarry to post a reply
  Future<void> _showNoAccountWarning() async {
    if (replyController.text != "") {  
      replyController.text = "";
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text("You must have an account to post a reply."),
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

}