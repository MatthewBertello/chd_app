import 'package:chd_app/components/default_app_bar.dart';
import 'package:chd_app/models/question_forum_model/question_forum_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditReply extends StatefulWidget {
  const EditReply({super.key,required this.questionForumModel, required this.reply, required this.questionIndex, required this.replyIndex});

  final QuestionForumModel questionForumModel;
  final String reply;
  final int questionIndex;
  final int replyIndex;

  @override
  State<EditReply> createState() => _EditReplyState();
}

class _EditReplyState extends State<EditReply> {
  TextEditingController editReplyController = TextEditingController();

  // set the controller to the old reply right away
  @override
  void initState() {
    super.initState();
    editReplyController.text = widget.reply;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
      context: context,
      title: const Text("Edit Reply"),
    ),
    body:
      Padding(
        padding: const EdgeInsets.all(8.0), 
        child: Column( 
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField( // where the user enters a new question
              controller: editReplyController,
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
              onPressed: _editReply,
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))),
              child: const Text('Confirm Edit')
            )              
          ],  
        )
      )
    );
  }

  // edits the reply
  void _editReply() {
    widget.questionForumModel.editReply(widget.questionIndex, widget.replyIndex, editReplyController.text);
    Navigator.pop(context);
  }


}