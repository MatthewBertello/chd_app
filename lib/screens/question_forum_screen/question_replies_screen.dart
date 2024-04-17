import 'package:chd_app/components/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:chd_app/models/question_forum_model.dart';

class QuestionReplies extends StatefulWidget {
  const QuestionReplies({super.key, required this.questionForumModel, required this.questionIndex});

  final QuestionForumModel questionForumModel; // model
  final int questionIndex; // index of the question in the list

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